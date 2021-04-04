import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart';

class HelperWidgets {
  static Widget get nativeProgressIndicator => GetPlatform.isIOS
      ? CupertinoActivityIndicator()
      : CircularProgressIndicator();
  static void showLoadingDialog() {
    if (GetPlatform.isAndroid) {
      Get.dialog(
        AlertDialog(
          content: SizedBox(
            height: 64,
            width: 64,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            ),
          ),
        ),
      );
    } else {
      Get.dialog(CupertinoAlertDialog(
        content: SizedBox(
          height: 64,
          width: 64,
          child: Center(child: CupertinoActivityIndicator()),
        ),
      ));
    }
  }

  static void showErrorDialog(String errorMessage) {
    if (GetPlatform.isAndroid) {
      Get.dialog(
        AlertDialog(
          content: Text(errorMessage, textAlign: TextAlign.center),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Ok')),
          ],
        ),
      );
    } else {
      Get.dialog(CupertinoAlertDialog(
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Ok')),
        ],
      ));
    }
  }

  static void showBasicDialog(String title, String subtitle) =>
      Get.defaultDialog(
        title: title,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(subtitle, textAlign: TextAlign.center),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      );

  static void showAppSnackbar(String title, String message) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: Colors.white,
      duration: Duration(seconds: 5),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

bool isMobile(BuildContext context) {
  // final mq = MediaQuery.of(context);
  //
  //
  return Get.width < 1000;
}

Widget drawIllustration(String path) {
  return Image.asset(path);
}

final primaryColor = Color(0xff6C63FF);
