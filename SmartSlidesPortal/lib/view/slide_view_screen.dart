import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web/helper.dart';

Widget buildSlidePreview() {
  return Padding(
    padding: const EdgeInsets.only(top: 4, left: 8, right: 23, bottom: 4),
    child: AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        // width: 345.0,
        // height: 242.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.0),
          image: DecorationImage(
            image: const AssetImage('assets/slide1.png'),
            fit: BoxFit.cover,
          ),
          border: Border.all(width: 5.0, color: const Color(0xff2699fb)),
        ),
        child: Text("1"),
      ),
    ),
  );
}

Widget buildNotePreview() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: const AssetImage('assets/note1.png'),
            fit: BoxFit.cover,
          ),
          border: Border.all(width: 1.0, color: const Color(0xff707070)),
        ),
        child: Text("1"),
      ),
    ),
  );
}

Widget buildSlidesPreviewList(
    ScrollController _controller, Axis scrollDirection) {
  return Scrollbar(
    isAlwaysShown: true,
    thickness: scrollDirection == Axis.vertical ? 15 : 0,
    radius: Radius.circular(5),
    controller: _controller,
    child: ListView(
      controller: _controller,
      scrollDirection: scrollDirection,
      children: [
        buildSlidePreview(),
        buildSlidePreview(),
        buildSlidePreview(),
        buildSlidePreview(),
      ],
    ),
  );
}

Widget buildNotesPreviewList(Axis scrollDirection) {
  return ListView(
    scrollDirection: scrollDirection,
    children: [
      buildNotePreview(),
      buildNotePreview(),
      buildNotePreview(),
      buildNotePreview(),
    ],
  );
}

Widget buildSelectedSlide() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          'assets/slide1.png',
        ),
      ),
    ),
  );
  return Column(
    children: [
      Expanded(child: Container()),
      AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21.0),
            image: DecorationImage(
              image: const AssetImage('assets/slide1.png'),
              fit: BoxFit.cover,
            ),
            border: Border.all(width: 1.0, color: const Color(0xff707070)),
          ),
        ),
      ),
      Expanded(child: Container()),
    ],
  );
}

class SlideViewScreen extends StatelessWidget {
  final ScrollController controller = ScrollController();
  Widget buildWebLayout() {
    return Row(
      children: [
        Container(
          child: buildSlidesPreviewList(controller, Axis.vertical),
          width: 0.2.sw,
        ),
        VerticalDivider(
          width: 2,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: buildSelectedSlide(),
              ),
              Container(
                height: 0.2.sh,
                child: buildNotesPreviewList(Axis.horizontal),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: buildSelectedSlide(),
        ),
        Container(
          height: 0.15.sh,
          child: buildNotesPreviewList(Axis.horizontal),
        ),
        Container(
          height: 0.15.sh,
          child: buildSlidesPreviewList(controller, Axis.horizontal),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SmartSlides"),
          centerTitle: true,
        ),
        body: isMobile(context) ? buildMobileLayout() : buildWebLayout());
  }
}
