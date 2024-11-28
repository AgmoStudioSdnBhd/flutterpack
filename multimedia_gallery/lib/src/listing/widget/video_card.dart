import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:multimedia_gallery/src/extension/extension.dart';
import 'package:multimedia_gallery/src/listing/model/model.dart';

/// The video card. To display the video list card widget in the listing page.
class VideoCard extends StatefulWidget {
  const VideoCard({super.key, required this.model, required this.isLast});

  /// The video model. To get the video model data.
  final VideoModel model;

  /// The boolean of whether the audio model is the last in the list.
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
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: widget.model.path ?? '',
      thumbnailPath: thumbnailPath,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 100,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    final file = File(thumbnailFile.path);
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
                  child: SizedBox(
                      child: thumbnailBytes != null
                          ? Image(
                        image: thumbnailImg,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      )
                          : Container(width: 160, color: Colors.white54)))),
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
