import 'dart:io';
import 'dart:typed_data';

// import 'package:camera/camera.dart';
import 'package:camera/camera.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;

import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;
import 'package:path/path.dart' as path;

List<CameraDescription> cameras = [];

List<double> getXYCoordinatesFromMLOutput(
    Float64List mlOutput, int orgImgHeight, int orgImgWidth) {
  // first check if all zero which means object not detected
  if (mlOutput.reduce((value, element) => value + element) == 0.0) {
    return [0, 0, 0, 0];
  }
  // orgImgHeight = 2560;
  // orgImgWidth = 1440;
  final inputSize = 416;
  final resizeRatio =
      math.min(inputSize / orgImgHeight, inputSize / orgImgHeight);

  var xmin = mlOutput[0] - mlOutput[2] * 0.5;
  var ymin = mlOutput[1] - mlOutput[3] * 0.5;
  var xmax = mlOutput[0] + mlOutput[2] * 0.5;
  var ymax = mlOutput[1] + mlOutput[3] * 0.5;

  final dw = (inputSize - resizeRatio * orgImgHeight) / 2;
  final dh = (inputSize - resizeRatio * orgImgHeight) / 2;

  xmin = 1.0 * (xmin - dw) / resizeRatio;
  xmax = 1.0 * (xmax - dw) / resizeRatio;
  ymin = 1.0 * (ymin - dh) / resizeRatio;
  ymax = 1.0 * (ymax - dh) / resizeRatio;
  // return [xmin / 3.5, ymin / 3.5, xmax / 3.5, ymax / 3.5];
  return [xmin, ymin, xmax, ymax];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setEnabledSystemUIOverlays([]);
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  // ]);
  // cameras = await availableCameras();
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

preProcessVideo(String videoPath) async {
  var progress = 0.0.obs;
  Get.defaultDialog(
    title: "Processing Video",
    content: Obx(() => Padding(
          padding: const EdgeInsets.all(16.0),
          child: LinearProgressIndicator(
            value: progress.value,
          ),
        )),
  );

  List<double> projectorCoordinates = [];
  List<double> whiteboardCoordinates = [];
  List<File> allFiles = [];
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  final FlutterFFprobe flutterFFprobe = FlutterFFprobe();
  MediaInformation mediaInformation =
      await flutterFFprobe.getMediaInformation(videoPath);
  Map<dynamic, dynamic> mp = mediaInformation.getMediaProperties();
  final duration = (double.parse(mp['duration'])).floor();
  for (int i = 0; i < 30; i += 3) {
    final uint8list = await vt.VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: vt.ImageFormat.JPEG,
      timeMs: i * 1000,
      quality: 100,
    );
    final image = img.decodeImage(uint8list);
    final height = image.height;
    final width = image.width;

    img.Image resized = img.copyResize(image, height: 416, width: 416);
    // print(resized.getBytes(format: img.Format.bgr).first);
    final resizedBytes = resized.getBytes(format: img.Format.bgr);
    final normalized = resizedBytes.map((e) => e / 255).toList();

    final mlOutput = await platformChannel(Float64List.fromList(normalized));

    Float64List projectOutput = mlOutput.sublist(0, 6);
    Float64List whiteboardOutput = mlOutput.sublist(6, 12);
    Float64List personOutput = mlOutput.sublist(12, 18);
    List<double> personCorr =
        getXYCoordinatesFromMLOutput(personOutput, height, width);
    if (isObjectDetected(personCorr)) continue;

    List<double> projectCorr =
        getXYCoordinatesFromMLOutput(projectOutput, height, width);
    List<double> whiteboardCorr =
        getXYCoordinatesFromMLOutput(whiteboardOutput, height, width);

    projectorCoordinates = projectCorr;
    whiteboardCoordinates = whiteboardCorr;
    // x1 0
    // y1 1
    // x2 2
    // y2 3
    final croppedImage = img.copyCrop(
        image,
        whiteboardCorr[0].toInt(),
        whiteboardCorr[1].toInt(),
        whiteboardCorr[2].toInt() - whiteboardCorr[0].toInt(),
        whiteboardCorr[3].toInt() - whiteboardCorr[1].toInt());

    String tempFilePath = path.join(tempPath, "$i.png");
    final fileToWrite = File(tempFilePath)
      ..writeAsBytesSync(img.encodePng(croppedImage));
    allFiles.add(fileToWrite);
    print("$i done");
    progress.value = (i / duration);
  }
  final corFilePath = path.join(tempPath, "coordinates.txt");
  final corFile = File(corFilePath)
    ..writeAsString("$whiteboardCoordinates\n$projectorCoordinates");
  allFiles.add(corFile);
  final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

  final zipFile = File(path.join(downloadsDirectory.path, "SmartSlides.smrt"));
  try {
    await ZipFile.createFromFiles(
        sourceDir: tempDir, files: allFiles, zipFile: zipFile);
    print("DONE");
    Get.back();
  } catch (e) {
    print(e);
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
                  final picker = ImagePicker();
                  final pickedFile = await picker.getVideo(
                    source: ImageSource.gallery,
                  );

                  preProcessVideo(pickedFile.path);

                  // final uint8list = await vt.VideoThumbnail.thumbnailData(
                  //   video: pickedFile.path,
                  //   imageFormat: vt.ImageFormat.JPEG,

                  //   maxWidth:
                  //       168, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                  //   quality: 100,
                  // );
                  // final result = await ImageGallerySaver.saveImage(uint8list);

                  // print(uint8list);
                }
              },
              child: Text("Video")),
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final pickedFile = await picker.getImage(
                source: ImageSource.gallery,
              );
              final startTime = DateTime.now();
              final image =
                  img.decodeImage(File(pickedFile.path).readAsBytesSync());
              final height = image.height;
              final width = image.width;

              img.Image resized =
                  img.copyResize(image, height: 416, width: 416);
              // print(resized.getBytes(format: img.Format.bgr).first);
              final resizedBytes = resized.getBytes(format: img.Format.bgr);
              final normalized = resizedBytes.map((e) => e / 255).toList();

              final mlOutput =
                  await platformChannel(Float64List.fromList(normalized));

              Float64List projectOutput = mlOutput.sublist(0, 6);
              Float64List whiteboardOutput = mlOutput.sublist(6, 12);
              Float64List personOutput = mlOutput.sublist(12, 18);

              List<double> projectCorr =
                  getXYCoordinatesFromMLOutput(projectOutput, height, width);
              List<double> whiteboardCorr =
                  getXYCoordinatesFromMLOutput(whiteboardOutput, height, width);
              List<double> personCorr =
                  getXYCoordinatesFromMLOutput(personOutput, height, width);
              // x1 0
              // y1 1
              // x2 2
              // y2 3

              final croppedImage = img.copyCrop(
                  image,
                  whiteboardCorr[0].toInt(),
                  whiteboardCorr[1].toInt(),
                  whiteboardCorr[2].toInt() - whiteboardCorr[0].toInt(),
                  whiteboardCorr[3].toInt() - whiteboardCorr[1].toInt());

              final downloadsDirectory =
                  await DownloadsPathProvider.downloadsDirectory;
              String tempPath = downloadsDirectory.path;
              String tempFilePath = path.join(tempPath, "temp.png");
              final fileToUpload = File(tempFilePath)
                ..writeAsBytesSync(img.encodePng(croppedImage));
              print("done");

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => My2ndApp(imageFile, {
              //       'Whiteboard': whiteboardCorr,
              //       'Person': personCorr,
              //       'Projection': projectCorr,
              //     }),
              //   ),
              // );
            },
            child: Text(
              "Annotate Image",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
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

Future<Float64List> platformChannel(Float64List imageData) async {
  const platform = const MethodChannel('SmartSlidesRecorder/YOLO');
  try {
    final result =
        await platform.invokeMethod('getWhiteboardPredictions', imageData);
    print(result);
    return result;
  } on PlatformException catch (e) {
    print(e);
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
