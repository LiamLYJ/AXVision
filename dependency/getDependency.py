if __name__ == "__main__":
    import os
    try:
        src_root = os.environ['SRCROOT']
    except:
        src_root = './'

    dependency_root = os.path.join(src_root, 'dependency')
    os.chdir(dependency_root)

    # download dependency libs
    if os.path.exists('ofxiOSBoost'):
        print("dependency met")
    else:
        print('start downing dependency')
        file_id = "16rhAhJSPNya1cz3Di00c0rWUWWrv43yV"
        file_name = './dependency.zip'

        cmd = 'curl -sc /tmp/cookie \"https://drive.google.com/uc?export=download&id=%s\" > /dev/null'%(file_id)
        os.system(cmd)
        code = "$(awk '/_warning_/ {print $NF}' /tmp/cookie)"  
        cmd = 'curl -Lb /tmp/cookie \"https://drive.google.com/uc?export=download&confirm=%s&id=%s\" -o %s'%(code, file_id, file_name)
        os.system(cmd)

        cmd_unzip = "tar -zxvf {}".format(file_name)
        del_tar_file = "rm {}".format(file_name)
        os.system(cmd_unzip)
        os.system(del_tar_file)
        cmd_mv = 'mv ./dependency/* ./ && rm -r ./dependency'
        os.system(cmd_mv)

    # donwload vocabulary
    voc_save_path = os.path.join(src_root, 'AXVisionSDK/SLAM/ORB_SLAM/Data/')
    if os.path.exists(os.path.join(voc_save_path, "ORBvoc.txt")): 
        print('ORBvoc exits')
    else:
        print("start downlaod ORBvoc")
        download_path = "https://github.com/raulmur/ORB_SLAM/raw/master/Data/ORBvoc.txt.tar.gz"

        file_name = "ORBvoc.txt.tar.gz"
        cmd = 'wget --no-check-certificate -r %s -O %s'%(download_path, file_name) 
        os.system(cmd)
        cmd_unzip = "tar -zxvf {}".format(file_name)
        del_tar_file = "rm {}".format(file_name)
        os.system(cmd_unzip)
        os.system(del_tar_file)
        cmd_mv = 'mv ORBvoc.txt %s'%(voc_save_path)
        os.system(cmd_mv)
