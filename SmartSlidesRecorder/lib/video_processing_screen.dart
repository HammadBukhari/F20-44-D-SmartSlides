import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:recording/main.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;

import 'ML.dart';

class VideoProcessingScreen extends StatefulWidget {
  @override
  _VideoProcessingScreenState createState() => _VideoProcessingScreenState();
}

class _VideoProcessingScreenState extends State<VideoProcessingScreen> {
  Future<void> processPDF(String filePath) async {
    await File(filePath).copy(path.join(dirPath, 'slides.pdf'));
  }

  processFrame(int index, img.Image image) {
    print("doing $index");
  }

  Future<void> processVideo(String videoPath) async {
    List<File> allFiles = [];
    final FlutterFFprobe flutterFFprobe = FlutterFFprobe();
    MediaInformation mediaInformation =
        await flutterFFprobe.getMediaInformation(videoPath);
    Map<dynamic, dynamic> mp = mediaInformation.getMediaProperties();
    final duration = (double.parse(mp['duration'])).floor();
    int j = 0;
    for (int i = 0; i < duration; i += 2) {
      progress.value = i / duration;
      print("doing $j");
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
      final resizedBytes = resized.getBytes(format: img.Format.rgb);
      final normalized = resizedBytes.map((e) => e / 255).toList();

      final mlOutput = await platformChannel(Float64List.fromList(normalized));

      Float64List projectOutput = mlOutput.sublist(0, 6);
      Float64List whiteboardOutput = mlOutput.sublist(6, 12);
      Float64List personOutput = mlOutput.sublist(12, 18);
      List<double> personCorr =
          getXYCoordinatesFromMLOutput(personOutput, height, width);
      if (isObjectDetected(personCorr)) continue;

      // ignore: unused_local_variable
      List<double> projectCorr =
          getXYCoordinatesFromMLOutput(projectOutput, height, width);
      // ignore: unused_local_variable
      List<double> whiteboardCorr =
          getXYCoordinatesFromMLOutput(whiteboardOutput, height, width);

      // x1 0
      // y1 1
      // x2 2
      // y2 3
      // final croppedImage = img.copyCrop(
      //   image,
      //   projectCorr[0].toInt(),
      //   projectCorr[1].toInt(),
      //   projectCorr[2].toInt() - projectCorr[0].toInt(),
      //   projectCorr[3].toInt() - projectCorr[1].toInt(),
      // );

      String tempFilePath = path.join(dirPath, "$j.png");
      j++;

      final fileToWrite = File(tempFilePath)
        ..writeAsBytesSync(img.encodePng(image));
      allFiles.add(fileToWrite);
      // progress.value = (i / duration);
    }
    final corFilePath = path.join(dirPath, "coordinates.txt");
    File(corFilePath)
      ..writeAsStringSync("");
  }

  Future<void> createZipFile() async {
    final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

    var encoder = ZipFileEncoder();
    encoder.create(downloadsDirectory.path + "/" + 'SmartSlides.zip');
    encoder.addDirectory(Directory(dirPath));
    encoder.close();
  }

  @override
  void initState() {
    initPath();
    super.initState();
  }

  initPath() async {
    Directory tempDir = await getTemporaryDirectory();
    dirPath = tempDir.path;
    final filePickerDirectory = Directory(path.join(dirPath, "file_picker"));
    if (filePickerDirectory.existsSync())
      Directory(path.join(dirPath, "file_picker")).deleteSync(recursive: true);

    String tempFilePath = path.join(tempDir.path, "SmartSlides");
    final smartSlidesDirectory = Directory(tempFilePath);
    if (smartSlidesDirectory.existsSync()) {
      // delete all previous files
      smartSlidesDirectory.deleteSync(recursive: true);
    }
    // create directory for new files
    smartSlidesDirectory.createSync();
    dirPath = smartSlidesDirectory.path;
    print("directory init done");
  }

  String dirPath;
  String pdfFilePath;
  String videoFilePath;
  var progress = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create SmartSlides")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Step#1: Select Slides PDF",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Builder(
              builder: (context) {
                if (pdfFilePath == null)
                  return Center(
                    child: GFButton(
                      shape: GFButtonShape.pills,
                      onPressed: () async {
                        var result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        print(result.files.first.path);

                        if (result == null || result.files.isEmpty) {
                          Get.snackbar("Error", "Error reading PDF file");
                          return;
                        }
                        pdfFilePath = result.files.first.path;

                        setState(() {});
                      },
                      text: 'Select PDF',
                    ),
                  );
                return Icon(Icons.check);
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Step#2: Select Lecture Video",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Builder(
              builder: (context) {
                if (videoFilePath == null)
                  return Center(
                    child: GFButton(
                      shape: GFButtonShape.pills,
                      onPressed: () async {
                        final file = await ImagePicker()
                            .getVideo(source: ImageSource.gallery);
                        videoFilePath = file.path;
                        setState(() {});
                      },
                      text: 'Select Video',
                    ),
                  );
                return Icon(Icons.check);
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: GFButton(
                  fullWidthButton: true,
                  shape: GFButtonShape.pills,
                  onPressed: pdfFilePath == null || videoFilePath == null
                      ? null
                      : () async {
                          Get.defaultDialog(
                            title: "Processing Video",
                            content: Obx(() => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text((progress * 100).toStringAsFixed(1) + " %"),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: LinearProgressIndicator(
                                        value: progress.value,
                                      ),
                                    ),
                                  ],
                                )),
                          );
                          await processPDF(pdfFilePath);
                          await processVideo(videoFilePath);
                          await createZipFile();
                          progress.value = 1;
                          await Future.delayed(Duration(seconds: 1));
                          Get.back();
                          Get.defaultDialog(
                            title: "Success",
                            content: Center(
                              child: Text(
                                "Your SmartSlides have been saved  to Downloads folder",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            middleText: '',
                            confirm: TextButton(
                              onPressed: () {
                                Get.offAll(HomePage());
                              },
                              child: Text("OK"),
                            ),
                          );
                        },
                  text: "Start",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
