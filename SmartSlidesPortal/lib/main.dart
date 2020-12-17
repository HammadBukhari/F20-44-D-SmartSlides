import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:web/view/home_screen.dart';
import 'package:web/view/mobile_home_screen.dart';

import 'helper.dart';
import 'view/login_screen.dart';
import 'view/slide_view_screen.dart';

enum HomeScreenFragment {
  coursesList,
  lectureList,
  lectureDetail,
}

class HomeScreenFragmentChangeNotification extends Notification {
  HomeScreenFragment currentFragment;
  HomeScreenFragment destFragment;
  HomeScreenFragmentChangeNotification({
    this.currentFragment,
    this.destFragment,
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(MyApp());
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => MyApp(), // Wrap your app
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        ScreenUtil.init(
          context,
        );
        return MaterialApp(
          home:
              LoginScreen(),//SlideViewScreen(), //isMobile(context) ? MobileHomeScreen() : HomeScreen(),
          locale: DevicePreview.locale(context), // Add the locale here
          builder: DevicePreview.appBuilder, // Add the builder here

          debugShowCheckedModeBanner: true,
        );
      },
    );
  }
}
