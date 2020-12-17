import 'package:flutter/cupertino.dart';

bool isMobile(BuildContext context) {
  final mq = MediaQuery.of(context);
  return mq.size.width < 1000;
}
final primaryColor = Color(0xff6C63FF);
