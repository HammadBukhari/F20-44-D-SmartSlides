import glob
import os
import shutil

list_dir = glob.glob(os.getcwd() + "/*/")

print(list_dir)

for i in range(1,len(list_dir)):
    list_xml = glob.glob(list_dir[i] + "*.jpg")
    for j in range(0,len(list_xml)):
        shutil.copy(list_xml[j], (list_dir[0] + "/whiteboard"))