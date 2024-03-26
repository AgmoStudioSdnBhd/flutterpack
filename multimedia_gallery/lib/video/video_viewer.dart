import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_gallery/extension/constants.dart';
import 'package:multimedia_gallery/video/widget/video_overlay_widget.dart';
import 'package:video_player/video_player.dart';

/// The VideoViewer class. This class can be called when need to display the video
/// player. Required parameter: [path]
class VideoViewer extends StatefulWidget {
  const VideoViewer(
      {super.key,
      required this.path,
      this.sliderStyle,
      this.timeStampStyle,
      this.onChangeEnd,
      this.onSliderChange,
      this.videoAspectRatio,
      this.onVideoScreenTap,
      this.backgroundColor});

  final VideoPlayerController path;
  final SliderThemeData? sliderStyle;
  final TextStyle? timeStampStyle;
  final Function(double)? onSliderChange;
  final Function(double)? onChangeEnd;
  final double? videoAspectRatio;
  final void Function()? onVideoScreenTap;
  final Color? backgroundColor;

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController controller;

  /// The [controller.inintialize] method. Use to call for initialize the
  /// video player controller
  late Future<void> initializeVideoPlayerFuture;

  /// The video timestamp controller. This timer object is call for the video
  /// player current timestamp.
  late Timer videoTimestamp;

  /// The show overlay timer. This timer object is call for the video overlay
  /// to hide after the overlay widgets is shown for 5 seconds.
  late Timer disableShowIconTimer;

  /// The hide and show for video overlay widgets.
  bool isShowIcon = false;

  /// The slider value to be use on updating the slider.
  double sliderValue = 0;

  /// The video player current timestamp.
  Duration currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    controller = widget.path;
    initializeVideoPlayerFuture = controller.initialize();
    playVideo();
    startTimer();
  }

  @override
  void dispose() {
    controller.dispose();
    videoTimestamp.cancel();
    super.dispose();
  }

  /// The video duration getter. To get the duration of the audio file.
  Duration getVideoDuration() => controller.value.duration;

  /// The video player timestamp controller. This method is to update the [timestamp] and
  /// the [sliderValue] of the video player. This method will be prompt on [initState]
  /// to start playing the video while updating the current timestamp and the slider value.
  void startTimer() {
    videoTimestamp = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (controller.value.duration != Duration.zero) {
        if (controller.value.position.inMilliseconds <
            controller.value.duration.inMilliseconds) {
          setState(() {
            controller.value.position.inMilliseconds.toDouble();
            currentPosition = controller.value.position;
          });
        } else {
          onVideoCompleted();
          controller.value.duration;
          timer.cancel();
        }
      } else {
        getVideoDuration();
      }
    });
  }

  /// The video [onComplete] controller. This method is to control the activity after
  /// the video is done playing.
  void onVideoCompleted() {
    setState(() {
      controller.value.duration.inMilliseconds.toDouble();
    });
  }

  /// The video timestamp update method. This method is to update the timestamp
  /// of the video by the slider value. This method will be call after sliding the
  /// video slider.
  void _seekTo(double value) {
    setState(() {
      controller.seekTo(Duration(milliseconds: value.toInt()));
    });
  }

  /// The video player state controller. This method is to update the state of the
  /// video to [controller.play]. This method only can be invoke if the state of the
  /// video player is [controller.pause] and the path is [notnull].
  void playVideo() {
    controller.play();
  }

  /// The video player state controller. This method is to update the state of the
  /// video to [controller.pause]. This method only can be invoke if the state of the
  /// video player is [controller.play] and the path is [notnull].
  void pauseVideo() {
    controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    /// To set the device orientation of the video viewer to include all orientation.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return OrientationBuilder(builder: (context, orientation) {
      final isPortrait = orientation == Orientation.portrait;
      return Scaffold(
          backgroundColor: widget.backgroundColor ??
              (isDarkMode ? Colors.black : Colors.white),
          appBar: isPortrait
              ? AppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: backButton,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  backgroundColor: Colors.transparent)
              : null,
          body: FutureBuilder(
              future: initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? isPortrait
                        ? _buildPortraitVideo(isPortrait)
                        : _buildLandscapeVideo(isPortrait)
                    : Container(
                        color: Colors.white,
                        alignment: Alignment.topCenter,
                        child: loadingIndicator());
              }));
    });
  }

  Widget _buildPortraitVideo(bool isPortrait) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        // Fill the screen with white color
        child: AspectRatio(
            aspectRatio: videoAspectRatio, child: _buildVideo(isPortrait)));
  }

  Widget _buildLandscapeVideo(bool isPortrait) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return Stack(children: [_buildVideo(isPortrait)]);
  }

  Widget _buildVideo(bool isPortrait) {
    return InkWell(
        onTap: widget.onVideoScreenTap ??
            () {
              setState(() {
                isShowIcon = !isShowIcon;
              });
            },
        child: Stack(children: [
          VideoPlayer(controller),
          Visibility(
              visible: isShowIcon,
              child: VideoOverlay(
                isPortrait: isPortrait,
                controller: controller,
                onPlayPressed: () {
                  setState(() {
                    if (controller.value.isPlaying) {
                      pauseVideo();
                    } else {
                      playVideo();
                    }
                  });
                },
                onSliderChange: (value) {
                  setState(() => value);
                },
                onChangeEnd: (value) {
                  _seekTo(value);
                },
              ))
        ]));
  }
}
