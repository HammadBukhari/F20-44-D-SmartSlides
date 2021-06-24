import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:web/helper.dart';
import 'package:web/view/image_viewer_screen.dart';

class SlideViewScreen extends StatefulWidget {
  final Map<String, List<String>> smartSlides;

  const SlideViewScreen({Key key, this.smartSlides}) : super(key: key);
  @override
  _SlideViewScreenState createState() => _SlideViewScreenState(smartSlides);
}

class _SlideViewScreenState extends State<SlideViewScreen> {
  final ScrollController controller = ScrollController();
  String currentSlide;
  List currentNotes;

  Map<String, List<String>> smartSlides;

  _SlideViewScreenState(this.smartSlides);

  String getUrlOfImage(String imageName) {
    return 'https://storage.googleapis.com/smartslides-b916a.appspot.com/$imageName';
  }

  @override
  void initState() {
    currentNotes = smartSlides[smartSlides.keys.first];
    currentSlide = smartSlides.keys.first;
    super.initState();
  }

  Widget buildSlidePreview(String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8, right: 23, bottom: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            currentSlide = name;
            currentNotes = smartSlides[name];
          });
        },
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            child: CachedNetworkImage(
              imageUrl: getUrlOfImage(name),
              progressIndicatorBuilder: (context, url, progress) {
                return Center(
                    child: CircularProgressIndicator(
                  value: progress.progress,
                ));
              },
            ),
            // width: 345.0,
            // height: 242.0,
            // decoration:
            // BoxDecoration(
            //   borderRadius: BorderRadius.circular(22.0),
            //   image: DecorationImage(
            //     image: AssetImage(path),
            //     fit: BoxFit.cover,
            //   ),
            //   border: Border.all(width: 5.0, color: const Color(0xff2699fb)),
            // ),
          ),
        ),
      ),
    );
  }

  Widget buildNotePreview(String path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 3 / 3,
        child: Container(
          child: CachedNetworkImage(
            imageUrl: getUrlOfImage(path),
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) {
              return Center(
                  child: CircularProgressIndicator(
                value: progress.progress,
              ));
            },
          ),
          // decoration:
          // BoxDecoration(
          //   borderRadius: BorderRadius.circular(15.0),
          //   image: DecorationImage(
          //     image: AssetImage(path),
          //     fit: BoxFit.cover,
          //   ),
          //   border: Border.all(width: 1.0, color: const Color(0xff707070)),
          // ),
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
        children: smartSlides.keys.map((e) => buildSlidePreview(e)).toList(),
      ),
    );
  }

  Widget buildNotesPreviewList(Axis scrollDirection) {
    return ListView(
      scrollDirection: scrollDirection,
      children: currentNotes
          .map(
            (e) => InkWell(
              onTap: () {
                Get.to(ImageViewerScreen(
                  imageUrl: getUrlOfImage(e),
                ));
              },
              child: buildNotePreview(e),
            ),
          )
          .toList(),
    );
  }

  Widget buildSelectedSlide() {
    return InkWell(
      onTap: () {
        Get.to(ImageViewerScreen(
          imageUrl: getUrlOfImage(currentSlide),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: getUrlOfImage(currentSlide),
                progressIndicatorBuilder: (context, url, progress) {
                  return Center(
                      child: CircularProgressIndicator(
                    value: progress.progress,
                  ));
                },
              )),
        ),
      ),
    );
  }

  Widget buildWebLayout() {
    return Row(
      children: [
        Container(
          width: 0.2.sw,
          child: buildSlidesPreviewList(controller, Axis.vertical),
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
