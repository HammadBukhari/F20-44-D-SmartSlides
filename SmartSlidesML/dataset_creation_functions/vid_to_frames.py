import cv2
import glob
import os


list_videos = glob.glob("*.m4v")

print(list_videos)
# Opens the Video file

count  = 0
for video in list_videos:
  dir_name = video[0:-4] + 'vidframes/'
  vidcap= cv2.VideoCapture(video)
  success,image = vidcap.read()
  if not os.path.exists(dir_name):
      os.makedirs(dir_name)
  save_frames = 0
  while success:
    if save_frames == 1:
      cv2.imwrite( dir_name + "frame%d.jpg" % count, image)     # save frame as JPG file      
      count += 1
    elif save_frames == 18:
      cv2.imwrite( dir_name + "frame%d.jpg" % count, image)
      count += 1
    elif save_frames == 31:
      save_frames = -1

    success,image = vidcap.read()
    save_frames += 1
  print(dir_name)

print(count)

