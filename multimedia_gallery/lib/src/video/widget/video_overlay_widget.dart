import 'package:flutter/material.dart';
import 'package:multimedia_gallery/src/extension/constants.dart';
import 'package:multimedia_gallery/src/extension/string_formatter.dart';
import 'package:multimedia_gallery/src/video/widget/video_slider_widget.dart';
import 'package:video_player/video_player.dart';

/// The video overlay widget. This widget is used to display the play, pause button,
/// back button and black overlay background.
class VideoOverlay extends StatelessWidget {
  const VideoOverlay(
      {super.key,
      required this.controller,
      required this.onPlayPressed,
      required this.isPortrait,
      this.overlayColor,
      this.backIcon,
      this.onBackButtonPressed,
      this.backButtonColor,
      this.iconSize,
      this.iconColor,
      this.sliderStyle,
      this.onSliderChange,
      this.onChangeEnd});

  /// The video player controller. To control the state of
  /// the video.
  final VideoPlayerController controller;

  /// The on play pressed function. To change the state of
  /// the video to [controller.play] or [controller.pause]
  final void Function() onPlayPressed;

  /// To check whether the device orientation is portrait or
  /// landscape and change the UI accordingly.
  final bool isPortrait;

  /// The overlay color of the video player.
  final Color? overlayColor;

  /// The onBackButtonPressed. To update the back button
  /// pressed activity.
  final void Function()? onBackButtonPressed;

  /// The back button icon.
  final Icon? backIcon;

  /// The back button color.
  final Color? backButtonColor;

  /// The video center icon size.
  final double? iconSize;

  /// The video center icon color.
  final Color? iconColor;

  /// The slider style.
  final SliderThemeData? sliderStyle;

  /// The on slider change function. To update the state of
  /// the slider when the slider value is changing.
  final void Function(double)? onSliderChange;

  /// The on slider change end function. To update the state of
  /// the slider when the slider value is changed.
  final void Function(double)? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    Widget centerIcon() {
      if (controller.value.isPlaying) {
        return const Icon(Icons.pause);
      } else if (controller.value.isBuffering) {
        return loadingIndicator();
      } else if (controller.value.isCompleted) {
        return const Icon(Icons.replay);
      } else {
        return const Icon(Icons.play_arrow);
      }
    }

    return Stack(children: [
      Positioned.fill(
        child: Container(color: overlayColor ?? Colors.black26),
      ),
      Container(
          child: isPortrait
              ? null
              : IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: backButton,
                  color: backButtonColor ?? Colors.white)),
      Center(
          child: IconButton(
              icon: centerIcon(),
              iconSize: iconSize ?? 50,
              color: iconColor ?? Colors.white,
              onPressed: onPlayPressed)),
      VideoSlider(
          data: sliderStyle,
          currentPosition: formatDuration(controller.value.position),
          videoDuration: formatDuration(controller.value.duration),
          child: Slider(
              value: controller.value.position.inMilliseconds.toDouble(),
              min: 0,
              max: controller.value.duration.inMilliseconds.toDouble(),
              onChanged: onSliderChange,
              onChangeEnd: onChangeEnd)),
    ]);
  }
}
