import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:web/Controller/LectureProvider.dart';
import 'package:web/Controller/PortalProvider.dart';
import 'package:web/main.dart';
import 'package:web/model/lecture.dart';
import 'package:web/model/portal.dart';
import 'package:web/view/add_lecture_screen.dart';
import 'package:web/view/mobile_home_screen.dart';
import 'package:web/view/slide_view_screen.dart';

import '../helper.dart';

ValueNotifier<HomeScreenFragment> currentFragment =
    ValueNotifier(HomeScreenFragment.coursesList);
Widget buildCoursesList() {
  final portals = GetIt.I<PortalProvider>().portals;
  // final selectedPortal = GetIt.I<PortalProvider>().selectedPortal.value;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: 10),
      Expanded(
        child: ListView.builder(
          itemCount: portals.length,
          itemBuilder: (context, index) {
            return ValueListenableBuilder<Portal>(
              valueListenable: GetIt.I<PortalProvider>().selectedPortal,
              builder: (context, selectedPortal, child) {
                return ListTile(
                  onTap: () {
                    currentFragment.value = HomeScreenFragment.lectureList;
                    GetIt.I<PortalProvider>().selectedPortal.value =
                        portals[index];
                  },
                  leading: Icon(Icons.arrow_forward_ios),
                  title: Text(portals[index].name),
                  selected: (index == 0 && selectedPortal == null) ||
                      (portals[index] == selectedPortal),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}

Widget buildUserProfileBadge(String name, String rollNo) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      GFAvatar(
        backgroundImage: AssetImage('assets/dummy_human.png'),
      ),
      SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xff2c2731),
              )),
          Text(rollNo,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xff2c2731),
              )),
        ],
      ),
    ],
  );
}

Widget buildQuestionAndItsResponses() {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(width: 10),
          GFAvatar(
            backgroundImage: AssetImage('assets/dummy_human.png'),
            size: 28,
          ),
          SizedBox(width: 10),
          Expanded(
            child: AutoSizeText(
              'What exactly cover the after part of User Experience?',
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
                  TextStyle(color: Colors.black26, fontFamily: 'WorkSansLight'),
              hintText: 'Be the first to answer this question'),
        ),
      ),
    ],
  );
}

Widget buildExpandedLectureDescQuestionsList() {
  return ListView(
    shrinkWrap: true,
    children: [
      buildQuestionAndItsResponses(),
      buildQuestionAndItsResponses(),
    ],
  );
}

Widget buildExpandedLectureDescHeader(
  BuildContext context,
  String title,
  String authorName,
  int slidesCount,
  String estTime,
) {
  final tableTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
    letterSpacing: 0.9,
    fontWeight: FontWeight.w300,
  );
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !isMobile(context)
            ? Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: Color(0xff000000).withOpacity(0.87),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(SlideViewScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: GFColors.PRIMARY,
                        ),
                        child: Center(
                          child: Text(
                            'Open SmartSlides',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: Color(0xff000000).withOpacity(0.87),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(SlideViewScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: GFColors.PRIMARY,
                        ),
                        child: Center(
                          child: Text(
                            'Open SmartSlides',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        Container(
          height: 1.00,
          color: Color(0xffefefef),
        ),
        SizedBox(height: 10),
        Container(
          width: 250,
          child: Table(
            children: [
              TableRow(
                children: [
                  Text(
                    'Created by',
                    style: tableTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  Text(authorName, style: tableTextStyle),
                ],
              ),
              TableRow(
                children: [
                  Text('Slides', style: tableTextStyle),
                  Text(slidesCount.toString(), style: tableTextStyle),
                ],
              ),
              TableRow(
                children: [
                  Text('Duration', style: tableTextStyle),
                  Text(estTime, style: tableTextStyle),
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
        //       backgroundImage: AssetImage("assets/dummy_human.png"),
        //     ),
        //     Text("Dr  ")
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
        //       backgroundImage: AssetImage("assets/dummy_human.png"),
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
  final portalProvider = GetIt.I<PortalProvider>();

  return ValueListenableBuilder<Lecture>(
    valueListenable: portalProvider.selectedLecture,
    builder: (context, lecture, child) {
      if (lecture == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/no_portal.jpeg',
                height: 100,
                width: 100,
              ),
              Text(
                  'Select a lecture from left bar or create one from using + button'),
            ],
          ),
        );
      }
      return Column(
        children: [
          buildExpandedLectureDescHeader(
            context,
            lecture.title,
            lecture.authorName,
            lecture.slidesCount,
            lecture.durationMin.toString(),
          ),
          buildExpandedLectureDescQuestionsList(),
        ],
      );
    },
  );
}

Widget buildCourseBar() {
  final user = GetIt.I<PortalProvider>().loginProvider.getLoggedInUser();
  final rollNo = user.email.substring(0, user.email.indexOf('@'));
  return Container(
    color: Color(0xffF4F4F4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        buildUserProfileBadge(user.name, rollNo),
        Expanded(child: buildCoursesList()),
      ],
    ),
  );
}

Widget buildCourseLectureTitle(BuildContext context, Lecture lecture) {
  final date = DateTime.fromMillisecondsSinceEpoch(lecture.creationTime);
  final dateString = DateFormat.MMMd('en_US').format(date);
  final portalProvider = GetIt.I<PortalProvider>();

  return ValueListenableBuilder<Lecture>(
      valueListenable: portalProvider.selectedLecture,
      builder: (context, value, w) {
        final isSelected =
            value != null && lecture.lectureId == value.lectureId;
        return InkWell(
          onTap: () {
            currentFragment.value = HomeScreenFragment.lectureDetail;
            portalProvider.selectedLecture.value = lecture;
          },
          child: Container(
            color: isSelected
                ? GFColors.PRIMARY.withOpacity(0.08)
                : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateString,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: Color(0xff000000).withOpacity(0.60),
                      )),
                  SizedBox(height: 5),
                  Text(
                    lecture.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xff000000).withOpacity(0.87),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(lecture.subtitle,
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Color(0xff000000).withOpacity(0.87),
                      )),
                  SizedBox(height: 5),
                  false
                      ? Container(
                          height: 22.00,
                          width: 95.00,
                          decoration: BoxDecoration(
                            color: GFColors.PRIMARY.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4.00),
                          ),
                          child: Center(
                            child: Text('NEW QUESTION',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 10,
                                  color: GFColors.PRIMARY,
                                )),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        );
      });
}

Widget courseHeaderBar() {
  final provider = GetIt.I<PortalProvider>();
  return ValueListenableBuilder(
    valueListenable: provider.selectedPortal,
    builder: (context, value, child) {
      final selectedPortal = provider.selectedPortal.value;
      final name = selectedPortal == null
          ? provider.portals.first.name
          : selectedPortal.name;
      final code = selectedPortal == null
          ? provider.portals.first.portalCode
          : selectedPortal.portalCode;
      return Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              Get.defaultDialog(
                title: 'Portal Code',
                middleText: 'Share this code for others to join',
                actions: [
                  Text(
                    code,
                    style: TextStyle(fontSize: 35),
                  ),
                ],
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100.0,
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: GFColors.PRIMARY,
                ),
                child: Center(
                  child: Text(
                    '+ Invite',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget buildCourseLecturesBar(BuildContext context) {
  return Stack(
    children: [
      Column(
        children: [
          courseHeaderBar(),
          Expanded(
            child: Obx(() {
              final lectureProvider = GetIt.I<LectureProvider>();
              return ListView.builder(
                itemBuilder: (c, i) {
                  final lecture =
                      lectureProvider.allLecturesOfSelectedPortal[i];

                  return buildCourseLectureTitle(context, lecture);
                },
                itemCount: lectureProvider.allLecturesOfSelectedPortal.length,
              );

              // return ListView(
              //   children: [
              //     buildCourseLectureTitle(context, 'Week 1 - Intro',
              //         'Introduction Lesson', 'Oct 2', true,
              //         isSelected: true),
              //     buildCourseLectureTitle(context, 'Week 2 - Basis of UX',
              //         'UX intro, UI vs UX', 'Oct 9', false,
              //         isSelected: false),
              //     buildCourseLectureTitle(
              //         context,
              //         'Week 3 - Usability Principles',
              //         'Building usable systems',
              //         'Oct 16',
              //         true,
              //         isSelected: false),
              //   ],
              // );
            }),
          ),
        ],
      ),
      Positioned(
        bottom: 5,
        right: 5,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(
              AddLectureScreen(
                portalId:
                    GetIt.I<PortalProvider>().selectedPortal.value.portalCode,
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    ],
  );
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final provider = GetIt.I<PortalProvider>();

  final nameController = TextEditingController();

  final codeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final sectionController = TextEditingController();

  bool isLoaded = false;

  final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90.0)),
      borderSide: BorderSide(color: Colors.white24));

  @override
  void initState() {
    super.initState();
    initPortals();
  }

  void initPortals() async {
    await provider.getAllPortalOfUser();
    isLoaded = true;
    setState(() {});
  }

  void buildJoinDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Join Portal',
      middleText: '',
      confirm: GFButton(
        onPressed: () async {
          Get.back();
          final code = codeController.text.trim();
          final result = await provider.joinPortal(code);
          if (result) {
            // ignore: unawaited_futures
            Get.defaultDialog(
              title: 'Portal Joined',
              middleText: code,
              middleTextStyle: TextStyle(fontSize: 35),
              confirm: GFButton(
                text: 'Okay',
                onPressed: () {
                  Get.back();
                  provider.newPortalCreated.value = false;
                },
              ),
            );
          } else {
            // ignore: unawaited_futures
            Get.defaultDialog(
              title: 'Incorrect Code',
              middleText:
                  'The code you entered does not match with any portal.',
              middleTextStyle: TextStyle(fontSize: 16),
              confirm: GFButton(
                text: 'Okay',
                onPressed: () {
                  Get.back();
                },
              ),
            );
          }
        },
        text: 'Join',
      ),
      actions: [
        TextFormField(
          controller: codeController,
          validator: RequiredValidator(errorText: 'Code is required'),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(24.0),
              prefixIcon: Icon(Icons.class_),
              border: borderStyle,
              hintStyle: TextStyle(
                color: Colors.black26,
              ),
              hintText: 'Portal Code'),
        ),
      ],
    );
  }

  void buildJoinOrCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GFButton(
                onPressed: () {
                  Get.back();
                  buildCreateDialog(context);
                },
                shape: GFButtonShape.pills,
                color: GFColors.PRIMARY,
                size: GFSize.LARGE,
                text: 'Create Portal',
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Text('OR'),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 15),
              GFButton(
                onPressed: () {
                  Get.back();
                  buildJoinDialog(context);
                },
                shape: GFButtonShape.pills,
                size: GFSize.LARGE,
                color: GFColors.PRIMARY,
                text: 'Join Portal',
              ),
            ],
          ),
        );
      },
    );
  }

  void buildCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: RequiredValidator(errorText: 'Name is required'),
                controller: nameController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(24.0),
                    prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                    border: borderStyle,
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    hintText: 'Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: RequiredValidator(errorText: 'Section is required'),
                controller: sectionController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(24.0),
                    prefixIcon: Icon(Icons.class_),
                    border: borderStyle,
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    hintText: 'Section'),
              ),
            ],
          ),
          actions: [
            GFButton(
              onPressed: () async {
                Get.back();

                final name = nameController.text.trim();
                final section = sectionController.text.trim();

                final code = await provider.createPortal(name, section);
                Get.back();
                // ignore: unawaited_futures
                buildGroupCreatedDialog(code);
              },
              text: 'Create',
            ),
          ],
        );
      },
    );
  }

  buildGroupCreatedDialog(String code) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Portal Created'),
          contentTextStyle: TextStyle(fontSize: 35),
          content: Text(code),
          actions: [
            GFButton(
              text: 'Okay',
              onPressed: () {
                Get.back();
                // Get.off(HomeScreen());
                provider.newPortalCreated.value = true;
              },
            ),
          ],
        );
      },
    );

    Get.defaultDialog(
      title: 'Portal Created',
      middleText: code,
      middleTextStyle: TextStyle(fontSize: 35),
      actions: [
        Text(
          'Use code above to invite students',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SmartSlides'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              buildJoinOrCreateDialog(context);
            },
          ),
        ],
        backgroundColor: GFColors.PRIMARY,
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: provider.newPortalCreated,
        builder: (context, value, widget) {
          if (!isLoaded) {
            return Center(child: CircularProgressIndicator());
          }
          if (isLoaded && provider.portals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: isMobile(context) ? 150 : 250,
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: drawIllustration('assets/no_portal.jpeg'))),
                    SizedBox(height: 30),
                    Text(
                      'You are not a part of any portal\n Create one or join through code using "+" button above',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!isMobile(context)) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 250, child: buildCourseBar()),
                Container(
                  width: 400,
                  child: buildCourseLecturesBar(context),
                ),
                Expanded(
                  child: buildExpandedLectureDesc(context),
                )
              ],
            );
          }
          return MobileHomeScreen();
        },
      ),
    );
  }
}
