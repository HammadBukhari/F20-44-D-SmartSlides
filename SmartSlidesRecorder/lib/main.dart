import 'dart:io';
import 'dart:typed_data';

// import 'package:camera/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'dart:math' as math;

import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras = [];

List<double> getXYCordinatesFromMLOutput(
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
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
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
          RaisedButton(
            color: Colors.blue,
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
              final imageFile = File(pickedFile.path);

              img.Image resized =
                  img.copyResize(image, height: 416, width: 416);
              print(resized.getBytes(format: img.Format.bgr).first);
              final resizedBytes = resized.getBytes(format: img.Format.bgr);
              final nomalized = resizedBytes.map((e) => e / 255).toList();
              Float64List.fromList(nomalized);

              final mlOutput =
                  await platformChannel(Float64List.fromList(nomalized));

              Float64List projectOutput = mlOutput.sublist(0, 6);
              Float64List whiteboardOutput = mlOutput.sublist(6, 12);
              Float64List personOutput = mlOutput.sublist(12, 18);

              List<double> projectCorr =
                  getXYCordinatesFromMLOutput(projectOutput, height, width);
              List<double> whiteboardCorr =
                  getXYCordinatesFromMLOutput(whiteboardOutput, height, width);
              List<double> personCorr =
                  getXYCordinatesFromMLOutput(personOutput, height, width);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => My2ndApp(imageFile, {
                    'Whiteboard': whiteboardCorr,
                    'Person': personCorr,
                    'Projection': projectCorr,
                  }),
                ),
              );
            },
            child: Text(
              "Anotate Image",
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

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  Map<String, List<double>> corr;
  File widgetImage;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      startML();
    });
  }

  void startML() async {
    while (true) {
      final startTime = DateTime.now();
      // await Future.delayed(Duration(seconds: 5));
      final xfile = await controller.takePicture();
      // setState(() {
      //   widgetImage = File(xfile.path);
      // });
      // GallerySaver.saveImage(xfile.path);
      // return;
      // continue;
      final image = img.decodeImage(await xfile.readAsBytes());

      final height = 2560; //image.height;
      final width = 1440; //image.width;

      img.Image resized = img.copyResize(image, height: 416, width: 416);

      // print("height = " +
      //     resized.height.toString() +
      //     " width = " +
      //     resized.width.toString());
      // print(resized.getBytes(format: img.Format.bgr).first);
      final resizedBytes = resized.getBytes(format: img.Format.bgr);
      final nomalized = resizedBytes.map((e) => e / 255).toList();
      Float64List.fromList(nomalized);

      final mlOutput = await platformChannel(Float64List.fromList(nomalized));

      Float64List projectOutput = mlOutput.sublist(0, 6);
      Float64List whiteboardOutput = mlOutput.sublist(6, 12);
      Float64List personOutput = mlOutput.sublist(12, 18);

      List<double> projectCorr =
          getXYCordinatesFromMLOutput(projectOutput, height, width);
      List<double> whiteboardCorr =
          getXYCordinatesFromMLOutput(whiteboardOutput, height, width);
      print(whiteboardCorr);
      List<double> personCorr =
          getXYCordinatesFromMLOutput(personOutput, height, width);

      final endTime = DateTime.now();
      print(
          "took => " + endTime.difference(startTime).inMilliseconds.toString());

      corr = {
        'Whiteboard': whiteboardCorr,
        'Person': personCorr,
        'Projection': projectCorr,
      };

      setState(() {});
      // await Future.delayed(Duration(seconds: 2));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    final stackList = <Widget>[];
    // stackList.add(Image.file(widgetImage));
    stackList.add(
      Container(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),
      ),
    );
    if (corr == null) {
      return Container();
    }
    // whiteboard
    final whiteboardCor = corr['Whiteboard'];
    if (whiteboardCor.reduce((value, element) => value + element) != 0.0) {
      stackList.add(CustomPaint(
        painter: RectanglePainter(whiteboardCor[0], whiteboardCor[1],
            whiteboardCor[2], whiteboardCor[3], Colors.green, context),
      ));
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
      stackList.add(RotatedBox(
        quarterTurns: 0,
        child: CustomPaint(
          painter: RectanglePainter(projectCor[0], projectCor[1], projectCor[2],
              projectCor[3], Colors.red, context),
        ),
      ));
    }

    return RotatedBox(
      quarterTurns: 0,
      child: Stack(
        children: stackList,
      ),
    );

    // return RotatedBox(
    //   quarterTurns: 3,
    //   child: Container(
    //     child: CameraPreview(
    //       controller,
    //     ),
    //   ),
    // );
  }
}

void main2() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await SystemChrome.setEnabledSystemUIOverlays([]);
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  // ]);
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(
    source: ImageSource.gallery,
  );
  final startTime = DateTime.now();
  final image = img.decodeImage(File(pickedFile.path).readAsBytesSync());
  final height = image.height;
  final width = image.width;
  // final imageFile = File(pickedFile.path);

  img.Image resized = img.copyResize(image, height: 416, width: 416);
  Directory tempDir = await getTemporaryDirectory();

  final imageFile = File('${tempDir.path}/test.png')
    ..writeAsBytesSync(img.encodePng(resized));

  // final imageFile = print("height = " +
  //     resized.height.toString() +
  //     " width = " +
  //     resized.width.toString());
  print(resized.getBytes(format: img.Format.bgr).first);
  final resizedBytes = resized.getBytes(format: img.Format.bgr);
  final nomalized = resizedBytes.map((e) => e / 255).toList();
  Float64List.fromList(nomalized);

  final mlOutput = await platformChannel(Float64List.fromList(nomalized));

  Float64List projectOutput = mlOutput.sublist(0, 6);
  Float64List whiteboardOutput = mlOutput.sublist(6, 12);
  Float64List personOutput = mlOutput.sublist(12, 18);

  List<double> projectCorr =
      getXYCordinatesFromMLOutput(projectOutput, height, width);
  List<double> whiteboardCorr =
      getXYCordinatesFromMLOutput(whiteboardOutput, height, width);
  List<double> personCorr =
      getXYCordinatesFromMLOutput(personOutput, height, width);

//   final input_size = 416;
//   final org_h = image.height;
//   final org_w = image.width;

// // #print("My points: ", cors)
//   final resize_ratio = math.min(input_size / org_w, input_size / org_h);

//   var xmin = array[0] - array[2] * 0.5;
//   var ymin = array[1] - array[3] * 0.5;
//   var xmax = array[0] + array[2] * 0.5;
//   var ymax = array[1] + array[3] * 0.5;

//   final dw = (input_size - resize_ratio * org_w) / 2;
//   final dh = (input_size - resize_ratio * org_h) / 2;

//   xmin = 1.0 * (xmin - dw) / resize_ratio;
//   xmax = 1.0 * (xmax - dw) / resize_ratio;
//   ymin = 1.0 * (ymin - dh) / resize_ratio;
//   ymax = 1.0 * (ymax - dh) / resize_ratio;

//   print(xmin.toString() +
//       " " +
//       xmax.toString() +
//       " " +
//       ymin.toString() +
//       " " +
//       ymax.toString());

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
  // final endTime = DateTime.now();
  // print("took => " + endTime.difference(startTime).inMilliseconds.toString());

  runApp(My2ndApp(imageFile, {
    'Whiteboard': whiteboardCorr,
    'Person': personCorr,
    'Projection': projectCorr,
  }));
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
      stackList.add(CustomPaint(
        painter: RectanglePainter(whiteboardCor[0], whiteboardCor[1],
            whiteboardCor[2], whiteboardCor[3], Colors.green, context),
      ));
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
