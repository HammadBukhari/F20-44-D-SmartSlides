import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web/helper.dart';

class SlideViewScreen extends StatefulWidget {
  @override
  _SlideViewScreenState createState() => _SlideViewScreenState();
}

class _SlideViewScreenState extends State<SlideViewScreen> {
  final ScrollController controller = ScrollController();
  String currentSlidePath = 'assets/slide1.png';

  Widget buildSlidePreview(String path) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8, right: 23, bottom: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            currentSlidePath = path;
          });
        },
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            // width: 345.0,
            // height: 242.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.0),
              image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.cover,
              ),
              border: Border.all(width: 5.0, color: const Color(0xff2699fb)),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNotePreview(String path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: AssetImage(path),
              fit: BoxFit.cover,
            ),
            border: Border.all(width: 1.0, color: const Color(0xff707070)),
          ),
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
          buildSlidePreview('assets/slide1.png'),
          buildSlidePreview('assets/slide2.png'),
          buildSlidePreview('assets/slide3.png'),
          buildSlidePreview('assets/slide1.png'),
        ],
      ),
    );
  }

  Widget buildNotesPreviewList(Axis scrollDirection) {
    return ListView(
      scrollDirection: scrollDirection,
      children: [
        buildNotePreview('assets/note1.png'),
        buildNotePreview('assets/note2.png'),
        buildNotePreview('assets/note3.png'),
        buildNotePreview('assets/note4.png'),
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
            currentSlidePath,
          ),
        ),
      ),
    );
  }

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
          title: Text('SmartSlides'),
          centerTitle: true,
        ),
        body: isMobile(context) ? buildMobileLayout() : buildWebLayout());
  }
}
