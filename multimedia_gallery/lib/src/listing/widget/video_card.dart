import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multimedia_gallery/src/extension/extension.dart';
import 'package:multimedia_gallery/src/listing/model/model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({super.key, required this.model, required this.isLast});

  final VideoModel model;
  final bool isLast;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  Uint8List? thumbnailBytes;
  String? thumbnailPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      generateThumbnail();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> generateThumbnail() async {
    final path = await VideoThumbnail.thumbnailFile(
      video: widget.model.path ?? '',
      thumbnailPath: thumbnailPath,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 100,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    final file = File(path ?? '');
    setState(() {
      thumbnailBytes = file.readAsBytesSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? thumbnailImg = MemoryImage(thumbnailBytes ?? Uint8List(8));
    String? dt = DateFormat('d MMMM yyyy hh:mm a')
        .format(DateTime.tryParse(widget.model.uploadedDate ?? '')?.toLocal() ??
            DateTime.now())
        .toString();

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: padding16,
        decoration: BoxDecoration(
            border: Border(
                bottom: widget.isLast
                    ? BorderSide.none
                    : BorderSide(color: mainListingBlack.withOpacity(0.6)))),
        child: Row(children: [
          Flexible(
              flex: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox.square(
                      dimension: 100,
                      child: thumbnailBytes != null
                          ? Image(
                              image: thumbnailImg,
                              fit: BoxFit.scaleDown,
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              color: Colors.white10)))),
          Flexible(
              flex: 4,
              child: Padding(
                  padding: padding16,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.model.name ?? '',
                            style: audioNameTextStyle),
                        Text(dt, style: const TextStyle(color: Colors.white))
                      ])))
        ]));
  }
}
