import sys 
import os 
import shutil
import requests

def download_file_from_google_drive(id, destination):
    URL = "https://docs.google.com/uc?export=download"

    session = requests.Session()

    response = session.get(URL, params = { 'id' : id }, stream = True)
    token = get_confirm_token(response)

    if token:
        params = { 'id' : id, 'confirm' : token }
        response = session.get(URL, params = params, stream = True)

    save_response_content(response, destination)    

def get_confirm_token(response):
    for key, value in response.cookies.items():
        if key.startswith('download_warning'):
            return value

    return None

def save_response_content(response, destination):
    CHUNK_SIZE = 32768

    with open(destination, "wb") as f:
        for chunk in response.iter_content(CHUNK_SIZE):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)

if __name__ == "__main__":
    folder_names = ['lab_roof.tar.gz', 'test_data.zip', 'sin2_tex2_h1_v8_d.zip']
    file_ids = ['1FbYXiuqNz0LR0xJN13YNKpqv6xVrZDlf', '1Do6FueskGzutUSIbm9EwxbzjhjVc-usN', '1MEVHMsZ2ekWdGkq7suoNHL77GMKH6Wu3']
    for folder_name, file_id in zip(folder_names, file_ids):
        pure_name = folder_name.replace('.zip', "").replace('.tar.gz', '') 
        if os.path.exists(pure_name):
            print("%s exists"%(pure_name))
        else:
            print('downdloading %s'%(pure_name))
            download_file_from_google_drive(file_id, folder_name)
            cmd_unzip = "tar -zxvf {}".format(folder_name) if 'tar' in folder_name else \
                        "unzip %s"%(folder_name)
            del_tar_file = "rm {}".format(folder_name)
            os.system(cmd_unzip)
            os.system(del_tar_file)