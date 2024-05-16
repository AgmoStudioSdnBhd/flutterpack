import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_gallery/extension/constants.dart';
import 'package:multimedia_gallery/extension/video_file_ext.dart';
import 'package:multimedia_gallery/listing/model/video_model.dart';
import 'package:multimedia_gallery/video/widget/video_overlay_widget.dart';
import 'package:video_player/video_player.dart';

/// The VideoViewer class. This class can be called when need to display the video
/// player. Required parameter: [path]
class VideoViewer extends StatefulWidget {
  const VideoViewer(
      {super.key,
      required this.model,
      required this.selected,
      this.sliderStyle,
      this.timeStampStyle,
      this.onChangeEnd,
      this.onSliderChange,
      this.videoAspectRatio,
      this.onVideoScreenTap,
      this.backgroundColor,
      this.portraitAppBar,
      this.overlayColor});

  final List<VideoModel> model;
  final int selected;
  final SliderThemeData? sliderStyle;
  final TextStyle? timeStampStyle;
  final Function(double)? onSliderChange;
  final Function(double)? onChangeEnd;
  final double? videoAspectRatio;
  final void Function()? onVideoScreenTap;
  final Color? backgroundColor;
  final AppBar? portraitAppBar;
  final Color? overlayColor;

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController controller;
  late int index = widget.selected;

  /// The [controller.inintialize] method. Use to call for initialize the
  /// video player controller
  late Future<void> initializeVideoPlayerFuture;

  /// The show overlay timer. This timer object is call for the video overlay
  /// to hide after the overlay widgets is shown for 5 seconds.
  Timer? disableShowIconTimer;

  /// The hide and show for video overlay widgets.
  bool isShowIcon = true;

  /// The video player current timestamp.
  Duration currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    initializeVideoController();
    playVideo();
    controller.addListener(() {
      setState(() {
        controller.value;
        currentPosition = controller.value.position;
        onVideoComplete();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initializeVideoController() {
    controller = networkVideo(widget.model[index].path ?? '');
    initializeVideoPlayerFuture = controller.initialize();
  }

  /// The video duration getter. To get the duration of the audio file.
  Duration getVideoDuration() => controller.value.duration;

  /// The video timestamp update method. This method is to update the timestamp
  /// of the video by the slider value. This method will be call after sliding the
  /// video slider.
  void _seekTo(double value) {
    setState(() {
      controller.seekTo(Duration(milliseconds: value.toInt()));
    });
  }

  void showIconTimerFunc() {
    disableShowIconTimer?.cancel();
    if (!controller.value.isCompleted ||
        controller.value.isLooping ||
        controller.value.isInitialized) {
      disableShowIconTimer?.tick;
      disableShowIconTimer = Timer.periodic(
          const Duration(seconds: 5),
          (timer) => setState(() {
                isShowIcon = false;
              }));
    }
  }

  void toggleOverlay() {
    isShowIcon = !isShowIcon;
    showIconTimerFunc();
  }

  void onVideoComplete() {
    if (controller.value.position.inMilliseconds.toDouble() ==
            controller.value.duration.inMilliseconds.toDouble() &&
        controller.value.isCompleted) {
      setState(() {
        isShowIcon = true;
        disableShowIconTimer?.cancel();
      });
    }
  }

  /// The video player state controller. This method is to update the state of the
  /// video to [controller.play]. This method only can be invoke if the state of the
  /// video player is [controller.pause] and the path is [notnull].
  void playVideo() {
    setState(() {
      controller.play();
      showIconTimerFunc();
    });
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
              ? widget.portraitAppBar ??
                  AppBar(
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
                        color: Colors.white54,
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Stack(children: [_buildVideo(isPortrait)]);
  }

  Widget _buildVideo(bool isPortrait) {
    return InkWell(
        onTap: widget.onVideoScreenTap ?? toggleOverlay,
        child: Stack(children: [
          VideoPlayer(controller),
          Visibility(
              visible: isShowIcon,
              child: VideoOverlay(
                overlayColor: widget.overlayColor,
                isPortrait: isPortrait,
                controller: controller,
                onPlayPressed: () {
                  setState(() {
                    if (controller.value.isPlaying) {
                      pauseVideo();
                    }
                    if (controller.value.isCompleted) {
                      playVideo();
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
