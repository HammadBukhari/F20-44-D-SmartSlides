# F20-44-D-SmartSlides
## Introduction 
This project involves the design and development of the SmartSlides system using machine learning where the student and teachers are provided with a cross-platform mobile application which through neural networks will automatically detect and process the whiteboard notes and PowerPoint slides and create SmartSlides. The SmartSlides have whiteboard notes and audio of the teacher according to individual slides. To enhance the communication after the class, we have also aimed to develop SmartSlides Portal, which will be the hub for discussion of lectures through questions and answers organized in an effective manner.
## Description of Repo
1. The **"SmartSlidesPortal"** folder contains flutter project for SmartSlides portal app for android, iOS and web app.
2. The **"SmartSlidesRecorder"** folder contains android app for recording the lecture which uses real-time machine learning to optimize the recording process. 
3. The **SmartSlidesML** contains code and our custom dataset link for machine learning.
### SmartSlidesPortal
The system consists of android, iOS and Web interface for SmartSlides Portal where teachers and students can upload SmartSlides reordered through *SmartSlidesRecorder* and have communication through its threaded question & response feature.
### SmartSlidesRecorder
The SmartSlidesRecorder is android app which use our custom trained TensorFlow lite ML model for process the recording of lecture.  The model looks for slide projection, whiteboard and notes on it and generate a SmartSlides file containing whiteboard notes for each slide and audio related to it. 
##Manual
### How to execute the SmartSlidesPortal from source code 
1.  Install flutter, VS code through https://flutter.dev/docs/get-started/install
2. Download code from classroom
3. Open VS code.
4. In VS code, click on File->Open Folder and choose the folder of code downloaded from classroom.
5. Connect an Android phone running Android 5.0+ (Supports web too).
6. Run app by clicking Run->Start Debugging

