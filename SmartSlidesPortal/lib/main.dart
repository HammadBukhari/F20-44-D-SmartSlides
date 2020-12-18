import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'package:web/view/home_screen.dart';
import 'package:web/view/mobile_home_screen.dart';

import 'Controller/LoginProvider.dart';
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
  final user = await FirebaseAuth.instance.currentUser;
  GetIt.I.registerSingleton<LoginProvider>(LoginProvider(user: user));
  if (user == null) {}
  // runApp(MyApp());
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => MyApp(
      initScreen: LoginScreen(
        onRegistrationMode: true,
      ),
    ), // Wrap your app
  ));
}

//isMobile(context) ? MobileHomeScreen() : HomeScreen(),
class MyApp extends StatelessWidget {
  final Widget initScreen;

  const MyApp({Key key, this.initScreen}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      allowFontScaling: false,
      child: GetMaterialApp(
        home: SafeArea(
          child: initScreen,
        ), //SlideViewScreen(),
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
