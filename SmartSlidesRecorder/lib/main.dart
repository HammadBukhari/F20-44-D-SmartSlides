import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIOverlays([]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
  // img.Image image = Image.asset("assets/img.jpg");
  const String yolo = "Tiny YOLOv2";

  final model = await Tflite.loadModel(
      model: "assets/model.tflite", labels: "assets/names.txt");
  print(model);
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(
    source: ImageSource.gallery,
    maxHeight: 416,
    maxWidth: 416,
  );

  var recognitions = await Tflite.detectObjectOnImage(
      path: pickedFile.path, model: "YOLO", asynch: true // defaults to true
      );
  print(recognitions);

  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recording',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final image = "assets/img.jpg";
  @override
  void initState() {
    super.initState();
    startImageStream();
  }

  bool isDetecting = false;

  Image imageWidget;
  bool isKeyboardDetected = false;
  CameraController controller;
  startImageStream() async {
    cameras = await availableCameras();
    controller = CameraController(cameras.first, ResolutionPreset.high);

    await controller.initialize();

    const String yolo = "Tiny YOLOv2";

    final model = await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/names.txt");

    print("Model loaded");
    await controller.startImageStream((image) {
      if (!isDetecting) {
        isDetecting = true;

        Tflite.detectObjectOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          model: 'YOLO',
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 0,
          imageStd: 255.0,
          numResultsPerClass: 1,
          threshold: 0.2,
        ).then((rec) {
          print(rec);
          if (rec.isNotEmpty) {
            for (final r in rec) {
              if (r['detectedClass'] == 'laptop')
                setState(() {
                  isKeyboardDetected = true;
                });
            }
          } else
            setState(() {
              isKeyboardDetected = false;
            });
          isDetecting = false;
        });

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.stop_circle,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            color: isKeyboardDetected
                ? Colors.transparent
                : Colors.black.withOpacity(0.7),
          ),
          Center(
            child: Text(
              isKeyboardDetected ? "Detected" : "Whiteboard Not detected",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    // return Scaffold(
    //   body:
    //       Center(child: Text(isKeyboardDetected ? "Detected" : "not detected")),
    // );
  }
}
