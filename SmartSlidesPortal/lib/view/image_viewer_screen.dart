import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerScreen extends StatefulWidget {
  final String imageUrl;

  const ImageViewerScreen({Key key, this.imageUrl}) : super(key: key);

  @override
  _ImageViewerScreenState createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    FocusScope.of(context).unfocus();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(
            widget.imageUrl,
            // progressIndicatorBuilder: (context, url, progress) {
            //   return CircularProgressIndicator(
            //     value: progress.progress,
            //   );
            // },
            // errorWidget: (context, url, error) {
            //   return Text("Unable to load image");
            // },
          ),
        ),
      ),
    );
  }
}
