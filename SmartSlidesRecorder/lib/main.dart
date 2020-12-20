import 'dart:io';
import 'dart:typed_data';

// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

// List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setEnabledSystemUIOverlays([]);
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  // ]);
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(
    source: ImageSource.gallery,
    maxHeight: 1000,
    maxWidth: 1000,
  );

  final array = platformChannel(pickedFile.path);
  final input_size = 416;
  final org_h = 1000;
  final org_w = 1000;

// #print("My points: ", cors)
// final resize_ratio = min(input_size / org_w, input_size / org_h);

// xmin = array[0] - array[2] * 0.5
// ymin = array[1] - array[3] * 0.5
// xmax = array[0] + array[2] * 0.5
// ymax = array[1] + array[3] * 0.5

// dw = (input_size - resize_ratio * org_w) / 2
// dh = (input_size - resize_ratio * org_h) / 2

// xmin = 1.0 * (xmin - dw) / resize_ratio
// xmax = 1.0 * (xmax - dw) / resize_ratio
// ymin = 1.0 * (ymin - dh) / resize_ratio
// ymax = 1.0 * (ymax - dh) / resize_ratio

  // ImageProcessor imageProcessor = ImageProcessorBuilder()
  //     .add(ResizeOp(416, 416, ResizeMethod.NEAREST_NEIGHBOUR))
  //     .add(NormalizeOp(0, 255))
  //     .build();

  // TensorImage tensorImage = TensorImage.fromFile(File(pickedFile.path));
  // img.Image image = img.decodeImage(File(pickedFile.path).readAsBytesSync());
  // print(image.data);
  // tensorImage = imageProcessor.process(tensorImage);
  // final ByteBuffer buffer = tensorImage.buffer;
  // print("width = " + tensorImage.width.toString());
  // print("height = " + tensorImage.height.toString());
  // print(tensorImage.buffer.asFloat64List());
  // print(tensorImage.buffer.asFloat32List().length);

  // platformChannel(buffer.());

  // runApp(My2ndApp(image));
}

class My2ndApp extends StatelessWidget {
  final File image;
  final int x1;
  final int y1;
  final int x2;
  final int y2;
  My2ndApp(this.image, this.x1, this.y1, this.x2, this.y2);

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: Image.file(image),
          ),
        ),
      ),
    );
  }
}

void platformChannel(String imageData) async {
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

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Recording',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final image = "assets/img.jpg";
//   @override
//   void initState() {
//     super.initState();
//     startImageStream();
//   }

//   bool isDetecting = false;

//   Image imageWidget;
//   bool isKeyboardDetected = false;
//   CameraController controller;
//   startImageStream() async {
//     cameras = await availableCameras();
//     controller = CameraController(cameras.first, ResolutionPreset.high);

//     await controller.initialize();

//     const String yolo = "Tiny YOLOv2";

//     final model = await Tflite.loadModel(
//         model: "assets/model.tflite", labels: "assets/names.txt");

//     print("Model loaded");
//     await controller.startImageStream((image) {
//       if (!isDetecting) {
//         isDetecting = true;

//         Tflite.detectObjectOnFrame(
//           bytesList: image.planes.map((plane) {
//             return plane.bytes;
//           }).toList(),
//           model: 'YOLO',
//           imageHeight: image.height,
//           imageWidth: image.width,
//           imageMean: 0,
//           imageStd: 255.0,
//           numResultsPerClass: 1,
//           threshold: 0.2,
//         ).then((rec) {
//           print(rec);
//           if (rec.isNotEmpty) {
//             for (final r in rec) {
//               if (r['detectedClass'] == 'laptop')
//                 setState(() {
//                   isKeyboardDetected = true;
//                 });
//             }
//           } else
//             setState(() {
//               isKeyboardDetected = false;
//             });
//           isDetecting = false;
//         });

//         setState(() {});
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (controller == null || !controller.value.isInitialized) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     return Scaffold(
//       body: Stack(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: RotatedBox(
//                   quarterTurns: 3,
//                   child: AspectRatio(
//                       aspectRatio: controller.value.aspectRatio,
//                       child: CameraPreview(controller)),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.stop_circle,
//                     color: Colors.red,
//                   ),
//                   onPressed: () {},
//                 ),
//               ),
//             ],
//           ),
//           AnimatedContainer(
//             duration: Duration(seconds: 1),
//             color: isKeyboardDetected
//                 ? Colors.transparent
//                 : Colors.black.withOpacity(0.7),
//           ),
//           Center(
//             child: Text(
//               isKeyboardDetected ? "Detected" : "Whiteboard Not detected",
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     // return Scaffold(
//     //   body:
//     //       Center(child: Text(isKeyboardDetected ? "Detected" : "not detected")),
//     // );
//   }
// }
