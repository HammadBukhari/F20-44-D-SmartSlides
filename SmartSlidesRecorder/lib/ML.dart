import 'dart:math' as math;

import 'dart:typed_data';

import 'package:flutter/services.dart';


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