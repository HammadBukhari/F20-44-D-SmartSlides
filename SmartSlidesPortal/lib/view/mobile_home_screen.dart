import 'package:flutter/material.dart';
import 'package:web/main.dart';
import 'home_screen.dart';

class MobileHomeScreen extends StatefulWidget {
  @override
  _MobileHomeScreenState createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    currentFragment.addListener(() {
      if (currentFragment.value == HomeScreenFragment.lectureList) {
        selectedIndex = 1;
      } else if (currentFragment.value == HomeScreenFragment.lectureDetail) {
        selectedIndex = 2;
      } else if (currentFragment.value == HomeScreenFragment.coursesList) {
        selectedIndex = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildCourseBar(),
          buildCourseLecturesBar(context),
          buildExpandedLectureDesc(context),
        ],
      ),
    );
  }
}
