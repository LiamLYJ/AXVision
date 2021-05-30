# Only for making calibration data. Independent with AXVisionSDK
import numpy as np
import cv2
import glob

objp = np.zeros((6 * 8, 3), np.float32)
objp[:,:2] = np.mgrid[0:8, 0:6].T.reshape(-1,2)

objpoints = [] #3d points in real world space
imgpoints = [] #2d points in image plane

images = glob.glob('./calibration/*.JPG')
img_size = (640, 480)

for idx, fname in enumerate(images):
    img = cv2.imread(fname)
    img = cv2.resize(img, img_size)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    print(fname)

    # Find the chessboard corners
    ret, corners = cv2.findChessboardCorners(gray, (8,6), None)

    # If found, add object points, image points
    if ret == True:
        objpoints.append(objp)
        imgpoints.append(corners)

        # Draw and display the corners
        cv2.drawChessboardCorners(img, (8,6), corners, ret)
        #write_name = 'corners_found'+str(idx)+'.jpg'
        #cv2.imwrite(write_name, img)
        cv2.imshow('img', img)
        cv2.waitKey(500)

cv2.destroyAllWindows()
ret, mtx, dist, rvecs, tvecs = cv2.calibrateCamera(objpoints, imgpoints, img_size, None, None)
print(mtx)
print(rvecs)
print(tvecs)
