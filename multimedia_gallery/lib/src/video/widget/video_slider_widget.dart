import 'package:flutter/material.dart';
import 'package:multimedia_gallery/src/extension/constants.dart';
import 'package:multimedia_gallery/src/extension/string_formatter.dart';

/// The video duration slider widget. This widget used to display the
/// slider widget to change ang show the timestamp of the video played.
class VideoSlider extends StatelessWidget {
  const VideoSlider(
      {super.key,
      required this.currentPosition,
      required this.child,
      required this.videoDuration,
      this.data});

  /// The current timestamp of the slider.
  final String currentPosition;

  /// The slider style.
  final SliderThemeData? data;

  /// The slider widget.
  final Widget child;

  /// The total duration of the audio.
  final String videoDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding16,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(formatVideoDuration(currentPosition, videoDuration),
                style: timestampTextStyle),
            SliderTheme(data: data ?? timeStampSlider, child: child),
          ]),
    );
  }
}
