import glob
import os
import xml.etree.ElementTree as ET

file_dirs = ["train/","test/"]

for file_dir in file_dirs:
    fdir = "custom_dataset/" + file_dir
    for directory in os.listdir(fdir):
        
        new_location = "/content/gdrive/My Drive/project/custom_dataset/" + file_dir + directory  
        xml_files = glob.glob(fdir + directory + "/*.xml")
        print((fdir + directory + "/" + "*.xml"))
        print(len(xml_files))
        for xml_file in xml_files: 
            tree = ET.parse(xml_file)
            root = tree.getroot()
            filename = root.find('filename')
            name = root[1].text 
            if name[0] == '\\': 
                name = name[1:]
            root[1].text = name
            frame_name = root[2].text[root[2].text.rfind('/') +1:]
            root[2].text = (new_location + "/" + frame_name)
            tree.write(fdir + directory + "/" + frame_name[:-4] + '.xml')