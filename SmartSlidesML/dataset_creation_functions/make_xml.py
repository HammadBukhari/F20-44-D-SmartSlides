import glob
import os
import xml.etree.ElementTree as ET

file_dir = "p (14)vidframes/" # change for each video
frames = glob.glob(file_dir +"*.jpg")

xml_file = "frame0.xml"

print(len(frames))
tree = ET.parse(xml_file)

root = tree.getroot()

for frame in frames: 
    filename = root.find('filename')
    root[1].text = frame[15:]
    root[2].text = (os.path.abspath(os.getcwd()) + "\\frames\\"+ frame)
    tree.write(file_dir + frame[15:-4] + '.xml')

