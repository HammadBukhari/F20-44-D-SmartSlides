import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:web/Controller/LectureProvider.dart';
import 'package:web/Controller/PortalProvider.dart';
import 'package:web/view/home_screen.dart';

import 'Controller/LoginProvider.dart';
import 'view/login_screen.dart';

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
  final user = FirebaseAuth.instance.currentUser;
  GetIt.I.registerSingleton(LoginProvider(user: user));
  GetIt.I.registerSingleton(PortalProvider());
  GetIt.I.registerSingleton(LectureProvider());
  final userLoggedIn = user != null;
  runApp(MyApp(
    initScreen: userLoggedIn
        ? HomeScreen()
        : LoginScreen(
            onRegistrationMode: true,
          ),
  ));
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     builder: (context) => MyApp(
  //       initScreen: userLoggedIn
  //           ? HomeScreen()
  //           : LoginScreen(
  //               onRegistrationMode: true,
  //             ),
  //     ), // Wrap your app
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  final Widget initScreen;

  const MyApp({Key key, this.initScreen}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      allowFontScaling: false,
      builder: () {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Container(
            color: Colors.white, //GFColors.PRIMARY,
            child: GetMaterialApp(
              home: SafeArea(
                child: initScreen,
              ), //SlideViewScreen(),
              debugShowCheckedModeBanner: false,
            ),
          ),
        );
      },
    );
  }
}
