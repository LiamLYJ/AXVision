import os,sys,argparse
import shutil 
import glob

if __name__=="__main__":

    CYELLOW = '\33[33m'
    CEND = '\033[0m'
    CRED    = '\33[31m'

    root_dir = os.path.dirname(os.path.realpath(__file__))
    work_dir = glob.glob(root_dir + '/**/AXVisionSDK/Info.plist', recursive=True)[0].strip('Info.plist')

    for folder in glob.glob(work_dir + '/*/'):
        module_dir = os.path.join(folder, 'C++')
        if os.path.exists(module_dir):
            build_dir = os.path.join(module_dir, 'build')
            os.makedirs(build_dir, exist_ok=True) 
            os.chdir(build_dir)
            module_name = build_dir.split('/')[-3]
            
            # test of this module is not implemented
            if not glob.glob(os.path.join(module_dir, 'test/*.cpp')):
                continue  
            print (CYELLOW + 'Runing test for module: %s'%(module_name) + CEND)
            command = "cmake .. && make -j4 && make test"
            if os.system(command) != 0:
                print(CRED + 'Test failed for module: %s'%(module_name) + CEND)
                raise ("Test failed to passed")
