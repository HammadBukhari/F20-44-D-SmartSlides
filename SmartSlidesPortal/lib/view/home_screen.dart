import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:web/main.dart';

ValueNotifier<HomeScreenFragment> currentFragment =
    ValueNotifier(HomeScreenFragment.coursesList);
Widget buildCoursesList(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // SizedBox(height: 10),
      // Text(
      //   "My Courses",
      //   style: TextStyle(
      //     fontSize: 21,
      //   ),
      // ),
      SizedBox(height: 10),
      Expanded(
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                // HomeScreenFragmentChangeNotification(
                //         currentFragment: HomeScreenFragment.coursesList,
                //         destFragment: HomeScreenFragment.lectureList)
                //     .dispatch(context);
                currentFragment.value = HomeScreenFragment.lectureList;
              },
              leading: Icon(Icons.arrow_forward_ios),
              title: Text('UXE'),
              selected: true,
            ),
            ListTile(
              leading: Icon(Icons.arrow_forward_ios),
              title: Text("HCI"),
            ),
            ListTile(
              leading: Icon(Icons.arrow_forward_ios),
              title: Text("FYP-2"),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildUserProfileBadge(BuildContext context, String name, String rollNo) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      GFAvatar(
        backgroundImage: AssetImage("assets/salman.png"),
      ),
      SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: TextStyle(
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xff2c2731),
              )),
          Text(rollNo,
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 14,
                color: Color(0xff2c2731),
              )),
        ],
      ),
    ],
  );
}

Widget buildQuestionAndItsResponses(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(width: 10),
          GFAvatar(
            backgroundImage: AssetImage("assets/salman.png"),
            size: 28,
          ),
          SizedBox(width: 10),
          Expanded(
            child: AutoSizeText(
              "What exactly cover the after part of User Experience?",
              maxLines: 3,
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(
          left: 32.0,
          top: 8,
          bottom: 8,
          right: 16,
        ),
        child: TextFormField(
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0.0),
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide(color: Colors.white24)
                  //borderSide: const BorderSide(),
                  ),
              hintStyle:
                  TextStyle(color: Colors.black26, fontFamily: "WorkSansLight"),
              hintText: "Be the first to answer this question"),
        ),
      ),
    ],
  );
}

Widget buildExpandedLectureDescQuestionsList(BuildContext context) {
  return ListView(
    shrinkWrap: true,
    children: [
      buildQuestionAndItsResponses(context),
      buildQuestionAndItsResponses(context),
    ],
  );
}

Widget buildExpandedLectureDescHeader(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: "SF Pro Display",
            fontWeight: FontWeight.w600,
            fontSize: 32,
            color: Color(0xff000000).withOpacity(0.87),
          ),
        ),
        new Container(
          height: 1.00,
          color: Color(0xffefefef),
        ),
        Container(
          width: 250,
          child: Table(
            children: [
              TableRow(
                children: [
                  Text(
                    'Created by',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0x99000000),
                      letterSpacing: 0.9,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text("Answer"),
                ],
              ),
              TableRow(
                children: [
                  Text("Last updated"),
                  Text("Answer"),
                ],
              ),
              TableRow(
                children: [
                  Text("Slides"),
                  Text("20"),
                ],
              ),
              TableRow(
                children: [
                  Text("Est. Time"),
                  Text("40 mins"),
                ],
              ),
            ],
          ),
        ),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text(
        //       "Created By: ",
        //       style: TextStyle(
        //         fontFamily: "SF Pro Display",
        //         fontWeight: FontWeight.w300,
        //         fontSize: 18,
        //         color: Color(0xff000000).withOpacity(0.60),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 10,
        //     ),
        //     GFAvatar(
        //       backgroundImage: AssetImage("assets/salman.png"),
        //     ),
        //     Text("Dr Amna ")
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text(
        //       "Questioners: ",
        //       style: TextStyle(
        //         fontFamily: "SF Pro Display",
        //         fontWeight: FontWeight.w300,
        //         fontSize: 18,
        //         color: Color(0xff000000).withOpacity(0.60),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 10,
        //     ),
        //     GFAvatar(
        //       backgroundImage: AssetImage("assets/salman.png"),
        //     ),
        //     Text("Dr Amna Besharat")
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text(
        //       "Last Updated: ",
        //       style: TextStyle(
        //         fontFamily: "SF Pro Display",
        //         fontWeight: FontWeight.w300,
        //         fontSize: 18,
        //         color: Color(0xff000000).withOpacity(0.60),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 10,
        //     ),
        //     Text("May 5, 2020 at 10:30 AM")
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text(
        //       "Slides: ",
        //       style: TextStyle(
        //         fontFamily: "SF Pro Display",
        //         fontWeight: FontWeight.w300,
        //         fontSize: 18,
        //         color: Color(0xff000000).withOpacity(0.60),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 10,
        //     ),
        //     Text("20")
        //   ],
        // ),
      ],
    ),
  );
}

Widget buildExpandedLectureDesc(BuildContext context) {
  return Column(
    children: [
      buildExpandedLectureDescHeader(context, "Week 1 - Introduction"),
      buildExpandedLectureDescQuestionsList(context),
    ],
  );
}

Widget buildCourseBar(BuildContext context) {
  return Container(
    color: Color(0xffF4F4F4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        buildUserProfileBadge(context, "Salman Mustufa", "17I-0111"),
        Expanded(child: buildCoursesList(context)),
      ],
    ),
  );
}

Widget buildCourseLectureTitle(BuildContext context, {bool isSelected = true}) {
  return InkWell(
    onTap: () {
      currentFragment.value = HomeScreenFragment.lectureDetail;
    },
    child: Container(
      color:
          isSelected ? Color(0xff32A05F).withOpacity(0.08) : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("May 5",
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color(0xff000000).withOpacity(0.60),
                )),
            SizedBox(height: 5),
            Text(
              "Week 1 - Intro",
              style: TextStyle(
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff000000).withOpacity(0.87),
              ),
            ),
            SizedBox(height: 10),
            Text("Introductory lesson",
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Color(0xff000000).withOpacity(0.87),
                )),
            SizedBox(height: 5),
            new Container(
              height: 22.00,
              width: 95.00,
              decoration: BoxDecoration(
                color: Color(0xff32A05F).withOpacity(0.12),
                borderRadius: BorderRadius.circular(4.00),
              ),
              child: Center(
                child: Text("NEW QUESTION",
                    style: TextStyle(
                      fontFamily: "SF Pro Display",
                      fontSize: 10,
                      color: Color(0xff32a05f),
                    )),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    ),
  );
}

Widget courseHeaderBar() {
  return Row(
    children: [
      SizedBox(
        width: 10,
      ),
      Text(
        "CS-504 UXE",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      Expanded(child: Container()),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 100.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: const Color(0xFF32A05F),
          ),
          child: Center(
            child: Text(
              "+ Invite",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildCourseLecturesBar(BuildContext context) {
  return Column(
    children: [
      courseHeaderBar(),
      Expanded(
        child: ListView(
          children: [
            buildCourseLectureTitle(context, isSelected: true),
            buildCourseLectureTitle(context, isSelected: false),
            buildCourseLectureTitle(context, isSelected: false),
            buildCourseLectureTitle(context, isSelected: false),
          ],
        ),
      ),
    ],
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SmartSlides'),
        centerTitle: true,
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 250, child: buildCourseBar(context)),
          Container(width: 400, child: buildCourseLecturesBar(context)),
          Expanded(
            child: buildExpandedLectureDesc(context),
          )
        ],
      ),
    );
  }
}
