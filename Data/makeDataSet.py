import cv2
import numpy as np
import glob
import os
import math
import csv
from pyquaternion import Quaternion

def get_distance(origin, destination):
    """
    Calculate the Haversine distance.

    Parameters
    ----------
    origin : tuple of float
        (lat, long)
    destination : tuple of float
        (lat, long)

    Returns
    -------
    distance_in_km : float

    Examples
    --------
    >>> origin = (48.1372, 11.5756)  # Munich
    >>> destination = (52.5186, 13.4083)  # Berlin
    >>> round(distance(origin, destination), 1)
    504.2
    """
    lat1, lon1 = origin
    lat2, lon2 = destination
    radius = 6378136.6

    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = (math.sin(dlat / 2) * math.sin(dlat / 2) +
         math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) *
         math.sin(dlon / 2) * math.sin(dlon / 2))
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    d = radius * c
    return d

def get_distance_lat_lon(origin, destination):
    # North-East-Down System, the positive X, Y and Z axes with the directions of North, East and down
    dis_lat = get_distance(origin, tuple([destination[0], origin[1]]))
    if destination[0] < origin[0]:
        dis_lat = -dis_lat
    dis_lon = get_distance(origin, tuple([origin[0], destination[1]]))
    if destination[1] < origin[1]:
        dis_lon = -dis_lon
    return dis_lat, dis_lon

def getGPS(file_name):
    position_from = os.popen("exiftool -b -gpsposition " + file_name).read()
    position_from = position_from.split(" ")
    return(float(position_from[0]), float(position_from[1]))

def getGimbalRollYawPitch(file_name):
    roll = os.popen("exiftool -b -gimbalrolldegree " + file_name).read()
    yaw = os.popen("exiftool -b -gimbalyawdegree " + file_name).read()
    pitch = os.popen("exiftool -b -gimbalpitchdegree " + file_name).read()
    return float(roll), float(yaw), float(pitch)

def getAltitude(file_name):
    altitude = os.popen("exiftool -b -relativealtitude " + file_name).read()
    return float(altitude)

def convertToCameraRollYawPitch(gim_roll, gim_yaw, gim_pitch):
    camera_roll = gim_roll
    camera_yaw = gim_yaw
    camera_pitch = gim_pitch + 90
    return camera_roll, camera_yaw, camera_pitch

def getDatasetInfoList(cur_file_name, ref_file_name):
    current_position = getGPS(cur_file_name)
    ref_position = getGPS(ref_file_name)
    x, y = get_distance_lat_lon(ref_position, current_position)
    ref_altitude = getAltitude(ref_file_name)
    cur_altitude = getAltitude(cur_file_name)
    z = -(cur_altitude - ref_altitude) # down is positive axis
    t_array = np.array([x, y, z])
    gimbal_roll, gimbal_yaw, gimbal_pitch = getGimbalRollYawPitch(cur_file_name)
    print(gimbal_roll, gimbal_yaw, gimbal_pitch)
    roll, yaw, pitch = convertToCameraRollYawPitch(gimbal_roll, gimbal_yaw, gimbal_pitch)
    q_roll = Quaternion(axis=[1, 0, 0], degrees=roll)
    q_pitch = Quaternion(axis=[0, 1, 0], degrees=pitch)
    q_yaw = Quaternion(axis=[0, 0, 1], degrees=yaw)
    q = q_roll * q_pitch * q_yaw
    print(q.rotation_matrix)
    print("===============")
    print(q.axis)
    print(q.degrees)
    q_inverse = q.inverse.normalised
    print("=======inverse========")
    print(q_inverse.axis)
    print(q_inverse.degrees)
    q_list = q_inverse.elements.tolist()
    q_list_output = q_list[1:] + [q_list[0]]
    image_file_name = cur_file_name.split("/")[-1].split(".")[0]+".png"
    result_row = [image_file_name]
    result_row.extend(t_array.tolist())
    result_row.extend(q_list_output)
    return result_row

image_folder_path = "./lab_depth/"
image_list = glob.glob(image_folder_path+"*.jpg")
image_list.sort()
dataset_name = "lab_roof/"
dataset_path = os.getcwd() + "/" + dataset_name
if not os.path.exists(dataset_path):
    os.mkdir(dataset_path)

ref_file_name = image_list[0]

with open(dataset_path + 'dataset_info.txt', 'w') as f:
    writer = csv.writer(f, delimiter=" ")
    for image_file in image_list:
        image = cv2.imread(image_file)
        image = cv2.resize(image, (640, 480), interpolation=cv2.INTER_AREA)
        image_file_name = image_file.split("/")[-1]
        image_file_name = image_file_name.split(".")[0] + ".png"
        cv2.imwrite(dataset_path + image_file_name, image)
        result_row = getDatasetInfoList(image_file, ref_file_name)
        writer.writerow(result_row)
