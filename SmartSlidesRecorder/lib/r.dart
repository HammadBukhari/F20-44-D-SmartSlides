// void main2() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // await SystemChrome.setEnabledSystemUIOverlays([]);
//   // await SystemChrome.setPreferredOrientations([
//   //   DeviceOrientation.landscapeLeft,
//   // ]);
//   final picker = ImagePicker();
//   final pickedFile = await picker.getImage(
//     source: ImageSource.gallery,
//   );
//   final startTime = DateTime.now();
//   final image = img.decodeImage(File(pickedFile.path).readAsBytesSync());
//   final height = image.height;
//   final width = image.width;
//   // final imageFile = File(pickedFile.path);

//   img.Image resized = img.copyResize(image, height: 416, width: 416);
//   Directory tempDir = await getTemporaryDirectory();

//   final imageFile = File('${tempDir.path}/test.png')
//     ..writeAsBytesSync(img.encodePng(resized));

//   // final imageFile = print("height = " +
//   //     resized.height.toString() +
//   //     " width = " +
//   //     resized.width.toString());
//   print(resized.getBytes(format: img.Format.bgr).first);
//   final resizedBytes = resized.getBytes(format: img.Format.bgr);
//   final nomalized = resizedBytes.map((e) => e / 255).toList();
//   Float64List.fromList(nomalized);

//   final mlOutput = await platformChannel(Float64List.fromList(nomalized));

//   Float64List projectOutput = mlOutput.sublist(0, 6);
//   Float64List whiteboardOutput = mlOutput.sublist(6, 12);
//   Float64List personOutput = mlOutput.sublist(12, 18);

//   List<double> projectCorr =
//       getXYCoordinatesFromMLOutput(projectOutput, height, width);
//   List<double> whiteboardCorr =
//       getXYCoordinatesFromMLOutput(whiteboardOutput, height, width);
//   List<double> personCorr =
//       getXYCoordinatesFromMLOutput(personOutput, height, width);

// //   final input_size = 416;
// //   final org_h = image.height;
// //   final org_w = image.width;

// // // #print("My points: ", cors)
// //   final resize_ratio = math.min(input_size / org_w, input_size / org_h);

// //   var xmin = array[0] - array[2] * 0.5;
// //   var ymin = array[1] - array[3] * 0.5;
// //   var xmax = array[0] + array[2] * 0.5;
// //   var ymax = array[1] + array[3] * 0.5;

// //   final dw = (input_size - resize_ratio * org_w) / 2;
// //   final dh = (input_size - resize_ratio * org_h) / 2;

// //   xmin = 1.0 * (xmin - dw) / resize_ratio;
// //   xmax = 1.0 * (xmax - dw) / resize_ratio;
// //   ymin = 1.0 * (ymin - dh) / resize_ratio;
// //   ymax = 1.0 * (ymax - dh) / resize_ratio;

// //   print(xmin.toString() +
// //       " " +
// //       xmax.toString() +
// //       " " +
// //       ymin.toString() +
// //       " " +
// //       ymax.toString());

//   // ImageProcessor imageProcessor = ImageProcessorBuilder()
//   //     .add(ResizeOp(416, 416, ResizeMethod.NEAREST_NEIGHBOUR))
//   //     .add(NormalizeOp(0, 255))
//   //     .build();

//   // TensorImage tensorImage = TensorImage.fromFile(File(pickedFile.path));
//   // img.Image image = img.decodeImage(File(pickedFile.path).readAsBytesSync());
//   // print(image.data);
//   // tensorImage = imageProcessor.process(tensorImage);
//   // final ByteBuffer buffer = tensorImage.buffer;
//   // print("width = " + tensorImage.width.toString());
//   // print("height = " + tensorImage.height.toString());
//   // print(tensorImage.buffer.asFloat64List());
//   // print(tensorImage.buffer.asFloat32List().length);

//   // platformChannel(buffer.());
//   // final endTime = DateTime.now();
//   // print("took => " + endTime.difference(startTime).inMilliseconds.toString());

//   runApp(My2ndApp(imageFile, {
//     'Whiteboard': whiteboardCorr,
//     'Person': personCorr,
//     'Projection': projectCorr,
//   }));
// }
// 
// 
// 
// 
// 
// 

  // void startML() async {
  //   while (true) {
  //     final startTime = DateTime.now();
  //     // await Future.delayed(Duration(seconds: 5));
  //     final xfile = await controller.takePicture();
  //     // setState(() {
  //     //   widgetImage = File(xfile.path);
  //     // });
  //     // GallerySaver.saveImage(xfile.path);
  //     // return;
  //     // continue;
  //     final image = img.decodeImage(await xfile.readAsBytes());

  //     final height = 2560; //image.height;
  //     final width = 1440; //image.width;

  //     img.Image resized = img.copyResize(image, height: 416, width: 416);

  //     // print("height = " +
  //     //     resized.height.toString() +
  //     //     " width = " +
  //     //     resized.width.toString());
  //     // print(resized.getBytes(format: img.Format.bgr).first);
  //     final resizedBytes = resized.getBytes(format: img.Format.bgr);
  //     final nomalized = resizedBytes.map((e) => e / 255).toList();
  //     Float64List.fromList(nomalized);

  //     final mlOutput = await platformChannel(Float64List.fromList(nomalized));

  //     Float64List projectOutput = mlOutput.sublist(0, 6);
  //     Float64List whiteboardOutput = mlOutput.sublist(6, 12);
  //     Float64List personOutput = mlOutput.sublist(12, 18);

  //     List<double> projectCorr =
  //         getXYCoordinatesFromMLOutput(projectOutput, height, width);
  //     List<double> whiteboardCorr =
  //         getXYCoordinatesFromMLOutput(whiteboardOutput, height, width);
  //     print(whiteboardCorr);
  //     List<double> personCorr =
  //         getXYCoordinatesFromMLOutput(personOutput, height, width);

  //     final endTime = DateTime.now();
  //     print(
  //         "took => " + endTime.difference(startTime).inMilliseconds.toString());

  //     corr = {
  //       'Whiteboard': whiteboardCorr,
  //       'Person': personCorr,
  //       'Projection': projectCorr,
  //     };

  //     setState(() {});
  //     // await Future.delayed(Duration(seconds: 2));
  //   }
  // }






// class CameraApp extends StatefulWidget {
//   @override
//   _CameraAppState createState() => _CameraAppState();
// }

// class _CameraAppState extends State<CameraApp> {
//   CameraController controller;
//   Map<String, List<double>> corr;
//   File widgetImage;

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(
//       cameras[0],
//       ResolutionPreset.high,
//     );
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//       startML();
//     });
//   }


//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     final stackList = <Widget>[];
//     // stackList.add(Image.file(widgetImage));
//     stackList.add(
//       Container(
//         child: AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: CameraPreview(
//             controller,
//           ),
//         ),
//       ),
//     );
//     if (corr == null) {
//       return Container();
//     }
//     // whiteboard
//     final whiteboardCor = corr['Whiteboard'];
//     if (whiteboardCor.reduce((value, element) => value + element) != 0.0) {
//       stackList.add(CustomPaint(
//         painter: RectanglePainter(whiteboardCor[0], whiteboardCor[1],
//             whiteboardCor[2], whiteboardCor[3], Colors.green, context),
//       ));
//     }

//     // person
//     final personCor = corr['Person'];
//     if (personCor.reduce((value, element) => value + element) != 0.0) {
//       stackList.add(CustomPaint(
//         painter: RectanglePainter(personCor[0], personCor[1], personCor[2],
//             personCor[3], Colors.yellow, context),
//       ));
//     }

//     // projection
//     final projectCor = corr['Projection'];
//     if (projectCor.reduce((value, element) => value + element) != 0.0) {
//       stackList.add(RotatedBox(
//         quarterTurns: 0,
//         child: CustomPaint(
//           painter: RectanglePainter(projectCor[0], projectCor[1], projectCor[2],
//               projectCor[3], Colors.red, context),
//         ),
//       ));
//     }

//     return RotatedBox(
//       quarterTurns: 0,
//       child: Stack(
//         children: stackList,
//       ),
//     );

//     // return RotatedBox(
//     //   quarterTurns: 3,
//     //   child: Container(
//     //     child: CameraPreview(
//     //       controller,
//     //     ),
//     //   ),
//     // );
//   }
// }

