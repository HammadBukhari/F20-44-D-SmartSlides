import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recording/video_processing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

bool isObjectDetected(List<double> coordinates) {
  return coordinates.reduce((value, element) => value + element) != 0.0;
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "SmartSlides Recorder",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 30,
            ),
          ),
          AspectRatio(
            aspectRatio: 2,
            child: Image.asset('assets/slides.png'),
          ),
          ElevatedButton(
              onPressed: () async {
                if (await Permission.storage.request().isGranted) {
                  Get.to(VideoProcessingScreen());
                }
              },
              child: Text("Create SmartSlides")),
          // ElevatedButton(
          //   onPressed: () async {
          //     final picker = ImagePicker();
          //     final pickedFile = await picker.getImage(
          //       source: ImageSource.gallery,
          //     );
          //     final startTime = DateTime.now();
          //     final image =
          //         img.decodeImage(File(pickedFile.path).readAsBytesSync());
          //     final height = image.height;
          //     final width = image.width;

          //     img.Image resized =
          //         img.copyResize(image, height: 416, width: 416);
          //     // print(resized.getBytes(format: img.Format.bgr).first);
          //     final resizedBytes = resized.getBytes(format: img.Format.bgr);
          //     final normalized = resizedBytes.map((e) => e / 255).toList();

          //     final mlOutput =
          //         await platformChannel(Float64List.fromList(normalized));

          //     Float64List projectOutput = mlOutput.sublist(0, 6);
          //     Float64List whiteboardOutput = mlOutput.sublist(6, 12);
          //     Float64List personOutput = mlOutput.sublist(12, 18);

          //     List<double> projectCorr =
          //         getXYCoordinatesFromMLOutput(projectOutput, height, width);
          //     List<double> whiteboardCorr =
          //         getXYCoordinatesFromMLOutput(whiteboardOutput, height, width);
          //     List<double> personCorr =
          //         getXYCoordinatesFromMLOutput(personOutput, height, width);
          //     // x1 0
          //     // y1 1
          //     // x2 2
          //     // y2 3

          //     final croppedImage = img.copyCrop(
          //         image,
          //         personCorr[0].toInt(),
          //         personCorr[1].toInt(),
          //         personCorr[2].toInt() - personCorr[0].toInt(),
          //         personCorr[3].toInt() - personCorr[1].toInt());

          //     final downloadsDirectory =
          //         await DownloadsPathProvider.downloadsDirectory;
          //     String tempPath = downloadsDirectory.path;
          //     String tempFilePath = path.join(tempPath, "temp.png");
          //     final fileToUpload = File(tempFilePath)
          //       ..writeAsBytesSync(img.encodePng(croppedImage));
          //     print("done");

          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) => My2ndApp(imageFile, {
          //     //       'Whiteboard': whiteboardCorr,
          //     //       'Person': personCorr,
          //     //       'Projection': projectCorr,
          //     //     }),
          //     //   ),
          //     // );
          //   },
          //   child: Text(
          //     "Annotate Image",
          //     style: TextStyle(
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final Color strokeColor;
  final BuildContext context;

  RectanglePainter(
    this.x1,
    this.y1,
    this.x2,
    this.y2,
    this.strokeColor,
    this.context,
  );
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = strokeColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromPoints(Offset(x1, y1), Offset(x2, y2)), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class My2ndApp extends StatelessWidget {
  final File image;
  final Map<String, List<double>> corr;

  My2ndApp(
    this.image,
    this.corr,
  );

  @override
  Widget build(
    BuildContext context,
  ) {
    final stackList = <Widget>[];
    stackList.add(Image.file(image));
    // whiteboard
    final whiteboardCor = corr['Whiteboard'];
    if (whiteboardCor.reduce((value, element) => value + element) != 0.0) {
      stackList.add(
        CustomPaint(
          painter: RectanglePainter(whiteboardCor[0], whiteboardCor[1],
              whiteboardCor[2], whiteboardCor[3], Colors.green, context),
        ),
      );
    }

    // person
    final personCor = corr['Person'];
    if (personCor.reduce((value, element) => value + element) != 0.0) {
      stackList.add(CustomPaint(
        painter: RectanglePainter(personCor[0], personCor[1], personCor[2],
            personCor[3], Colors.yellow, context),
      ));
    }

    // projection
    final projectCor = corr['Projection'];
    if (projectCor.reduce((value, element) => value + element) != 0.0) {
      stackList.add(CustomPaint(
        painter: RectanglePainter(projectCor[0], projectCor[1], projectCor[2],
            projectCor[3], Colors.red, context),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: stackList,
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.red,
                width: 5,
              )),
            ),
            title: Text("Projection"),
          ),
          ListTile(
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 5,
                ),
              ),
            ),
            title: Text("Whiteboard"),
          ),
          ListTile(
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.yellow,
                width: 5,
              )),
            ),
            title: Text("Person"),
          ),
        ],
      ),
    );
  }
}



// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Recording',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home: MyHomePage(),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   final image = "assets/img.jpg";
// //   @override
// //   void initState() {
// //     super.initState();
// //     startImageStream();
// //   }

// //   bool isDetecting = false;

// //   Image imageWidget;
// //   bool isKeyboardDetected = false;
// //   CameraController controller;
// //   startImageStream() async {
// //     cameras = await availableCameras();
// //     controller = CameraController(cameras.first, ResolutionPreset.high);

// //     await controller.initialize();

// //     const String yolo = "Tiny YOLOv2";

// //     final model = await Tflite.loadModel(
// //         model: "assets/model.tflite", labels: "assets/names.txt");

// //     print("Model loaded");
// //     await controller.startImageStream((image) {
// //       if (!isDetecting) {
// //         isDetecting = true;

// //         Tflite.detectObjectOnFrame(
// //           bytesList: image.planes.map((plane) {
// //             return plane.bytes;
// //           }).toList(),
// //           model: 'YOLO',
// //           imageHeight: image.height,
// //           imageWidth: image.width,
// //           imageMean: 0,
// //           imageStd: 255.0,
// //           numResultsPerClass: 1,
// //           threshold: 0.2,
// //         ).then((rec) {
// //           print(rec);
// //           if (rec.isNotEmpty) {
// //             for (final r in rec) {
// //               if (r['detectedClass'] == 'laptop')
// //                 setState(() {
// //                   isKeyboardDetected = true;
// //                 });
// //             }
// //           } else
// //             setState(() {
// //               isKeyboardDetected = false;
// //             });
// //           isDetecting = false;
// //         });

// //         setState(() {});
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (controller == null || !controller.value.isInitialized) {
// //       return Center(
// //         child: CircularProgressIndicator(),
// //       );
// //     }
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: RotatedBox(
// //                   quarterTurns: 3,
// //                   child: AspectRatio(
// //                       aspectRatio: controller.value.aspectRatio,
// //                       child: CameraPreview(controller)),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: IconButton(
// //                   icon: Icon(
// //                     Icons.stop_circle,
// //                     color: Colors.red,
// //                   ),
// //                   onPressed: () {},
// //                 ),
// //               ),
// //             ],
// //           ),
// //           AnimatedContainer(
// //             duration: Duration(seconds: 1),
// //             color: isKeyboardDetected
// //                 ? Colors.transparent
// //                 : Colors.black.withOpacity(0.7),
// //           ),
// //           Center(
// //             child: Text(
// //               isKeyboardDetected ? "Detected" : "Whiteboard Not detected",
// //               style: TextStyle(
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );

// //     // return Scaffold(
// //     //   body:
// //     //       Center(child: Text(isKeyboardDetected ? "Detected" : "not detected")),
// //     // );
// //   }
// // }
