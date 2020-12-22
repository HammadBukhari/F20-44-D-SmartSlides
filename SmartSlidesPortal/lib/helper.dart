import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_svg/svg.dart';

bool isMobile(BuildContext context) {
  final mq = MediaQuery.of(context);
  return mq.size.width < 1000;
}

Widget drawIllustration(String path) {
  return kIsWeb
      ? Image.network(
          path,
        )
      : SvgPicture.asset(path);
}

final primaryColor = Color(0xff6C63FF);
