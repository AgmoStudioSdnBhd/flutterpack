import 'package:flutter/material.dart';
import 'package:multimedia_gallery/extension/constants.dart';
import 'package:multimedia_gallery/extension/image_file_ext.dart';
import 'package:multimedia_gallery/listing/model/audio_model.dart';

class AudioCard extends StatelessWidget {
  const AudioCard({super.key, required this.model, required this.isLast});

  final AudioModel model;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    ImageProvider img = getImageSourceType(model.image);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: padding16,
      decoration: BoxDecoration(
          border: Border(
              bottom: isLast
                  ? BorderSide.none
                  : BorderSide(color: mainListingBlack.withOpacity(0.6)))),
      child: Row(children: [
        Flexible(
            flex: 1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox.square(
                  dimension: 100,
                  child: Image(
                    image: img,
                    fit: BoxFit.scaleDown,
                  ),
                ))),
        Flexible(
            flex: 4,
            child: Padding(
                padding: padding16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(model.audioName ?? '', style: audioNameTextStyle),
                    Text(model.artistName ?? '',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ))),
      ]),
    );
  }
}
