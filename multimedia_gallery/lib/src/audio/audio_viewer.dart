import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_gallery/src/extension/extension.dart';
import 'package:multimedia_gallery/src/audio/widget/image_background_gradient_widget.dart';
import 'package:multimedia_gallery/src/listing/model/audio_model.dart';

/// AudioViewer class to be used to get the audio player ui and function.
class AudioViewer extends StatefulWidget {
  final List<AudioModel> model;
  final int selectedIndex;
  final EdgeInsets? screenPadding;
  final double? imageWidth;
  final BorderRadius? imageBorder;
  final BoxFit? imageFit;
  final TextStyle? songNameTextStyle;
  final TextStyle? artistNameTextStyle;
  final SliderThemeData? sliderTheme;
  final Icon? icon;
  final ButtonStyle? iconStyle;
  final void Function()? onPressed;

  const AudioViewer(
      {super.key,
      required this.model,
      required this.selectedIndex,
      this.screenPadding,
      this.imageBorder,
      this.imageWidth,
      this.imageFit,
      this.artistNameTextStyle,
      this.songNameTextStyle,
      this.sliderTheme,
      this.icon,
      this.iconStyle,
      this.onPressed});

  @override
  State<AudioViewer> createState() => _AudioViewerState();
}

class _AudioViewerState extends State<AudioViewer> {
  late ScrollController _titleController;
  late ScrollController _artistController;

  /// The audio player controller. This [initialize] the audio player as the controller
  /// to listen to the event of the audio player.
  AudioPlayer player = AudioPlayer();

  /// The timestamp of audio. Will change according to the current timestamp
  /// of the audio being played
  Duration? audioTimestamp;

  /// The duration of the audio.
  Duration? audioDuration;

  /// The state of the audio player. The state can be updated to
  /// play, paused or resumed.
  PlayerState? state;

  /// The position of the slider thumb at the given timestamp.
  /// Will be updated based on the current timestamp of the audio being played.
  double? sliderPosition;

  /// The maximum position of the slider. The value is based on the
  /// duration of the audio file.
  double? sliderMaxPosition;

  /// The duration listener. Used to watch or listen to the
  /// duration of the audio file.
  StreamSubscription? durationSubscription;

  /// The timestamp listener. Used to watch or listen to the current
  /// timestamp and the position of the slider.
  StreamSubscription? positionSubscription;

  /// The audio completion listener. Used to watch or listen to the
  /// activity after the audio completed played.
  StreamSubscription? playerCompleteSubscription;

  /// The audio state listener. Used to watch or listen to the
  /// activity while the audio is played.
  StreamSubscription? playerStateChangeSubscription;

  late int index = widget.selectedIndex;
  late ImageProvider img = getImageSourceType(widget.model[index].image);

  @override
  void initState() {
    super.initState();
    textController();
    getDuration();
    playAudio();
    getCurrentTimestamp();
    playerController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    durationSubscription?.cancel();
    positionSubscription?.cancel();
    playerCompleteSubscription?.cancel();
    playerStateChangeSubscription?.cancel();
    player.dispose();
    super.dispose();
  }

  void textController() {
    _titleController = ScrollController();
    _artistController = ScrollController();
    _startAutoScroll(_titleController);
    _startAutoScroll(_artistController);
  }

  /// The text auto scroller. This scroll controller is to automate
  /// the text scroll from left to right the text is overflowing.
  void _startAutoScroll(ScrollController controller) {
    Timer.periodic(sec5, (_) {
      if (controller.hasClients) {
        double maxScrollExtent = controller.position.maxScrollExtent;
        double minScrollExtent = controller.position.minScrollExtent;
        if (controller.offset != maxScrollExtent) {
          controller.animateTo(maxScrollExtent,
              duration: sec12, curve: Curves.linear);
        } else {
          controller.animateTo(minScrollExtent,
              duration: sec10, curve: Curves.linear);
        }
      }
    });
  }

  /// This method is to play the audio file on [initState].
  /// This method will get the audio file path and play the audio file if the audio file can be found.
  void playAudio() {
    Source source = getAudioSourceType(widget.model[index].path ?? '');
    player.play(source);
  }

  /// This method is to set the state of the audio player to [play].
  /// This method only can be invoke if the audio file exists
  /// and the state of the audio player is pause.
  void resumeAudio() {
    player.resume();
  }

  /// This method is to set the state of the audio player to [pause].
  /// This method only can be invoke if the audio file exists
  /// and the state of the audio player is play.
  void pauseAudio() {
    player.pause();
  }

  /// This method is to set the duration of the audio file. This method is necessary to
  /// be invoke in the [initState] since [player.getDuration] is a future method.
  /// After the [player.getDuration] is invoked, a final parameter [audioDuration] is set to this value.
  void getDuration() {
    player.getDuration().then((value) => setState(() => audioDuration = value));
  }

  /// This method is to set the current timestamp that the audio file is played.
  /// This method is necessary to be invoked in [initState] since the player
  /// is a future method. After the [player.getCurrentPosition] is invoked, a
  /// final parameter [audioTimestamp] is set to this value.
  void getCurrentTimestamp() {
    player
        .getCurrentPosition()
        .then((value) => setState(() => audioTimestamp = value));
  }

  /// The audio player controller. This controller method is to listen and update
  /// the parameter to be updated.
  void playerController() {
    /// The audio duration listener. This is to update the audio file duration when
    /// there are changes to the audio duration. This method can be used when changing
    /// audio file to play.
    durationSubscription = player.onDurationChanged.listen((d) {
      setState(() {
        audioDuration = d;
        sliderMaxPosition = d.inMilliseconds.toDouble();
      });
    });

    /// The current timestamp listener. This listener is assign to update
    /// current timestamp and the slider thumb position when the audio player is running.
    positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() {
        audioTimestamp = p;
        sliderPosition = p.inMilliseconds.toDouble();
      }),
    );

    /// The audio onPlayerComplete listener. This listener is to update the parameter
    /// after the audio player has complete played.
    playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      onSkipNext();
    });

    /// The audio onPlayerComplete listener. This listener is to update the state
    /// of the audio player after the audio player has complete played.
    playerStateChangeSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {
        state = state;
      });
    });
  }

  /// The timestamp seeker. This method is to update the audio timestamp when the audio
  /// slider is slide to another timestamp.
  void seekTo(double value) {
    player.seek(Duration(milliseconds: value.round()));
  }

  void onSkipNext() {
    setState(() {
      state = PlayerState.stopped;
      if (index + 1 == widget.model.length) {
        index = 0;
      } else {
        index += 1;
      }
    });
    img = getImageSourceType(widget.model[index].image);
    player.play(UrlSource(widget.model[index].path ?? ''));
  }

  void onSkipPrevious() {
    setState(() {
      state = PlayerState.stopped;
      if (index == 0) {
        index = widget.model.length - 1;
      } else {
        index -= 1;
      }
    });
    img = getImageSourceType(widget.model[index].image);
    player.play(UrlSource(widget.model[index].path ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return isGif(widget.model[index].image ?? '')
        ? Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: img,
                    fit: BoxFit.fitHeight,
                    repeat: ImageRepeat.noRepeat)),
            child: Stack(
                children: [Container(color: Colors.black38), _buildContent()]))
        : GradientBackground(image: img, child: _buildContent());
  }

  Widget _buildContent() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
                icon: backButton,
                onPressed: () => Navigator.pop(context),
                color: Colors.white)),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight,
                padding: widget.screenPadding ?? padding16,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isGif(widget.model[index].image ?? '')
                          ? Flexible(
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2))
                          : Flexible(
                              child: FittedBox(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Card(
                                          elevation: 4,
                                          clipBehavior: Clip.antiAlias,
                                          child: Image(
                                              image: img,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .shortestSide /
                                                  2,
                                              fit: BoxFit.fill))))),
                      sizedBoxGapConstantH10,
                      Flexible(
                          flex: 2,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _titleController,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                          child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                  widget.model[index]
                                                          .audioName ??
                                                      '',
                                                  style: widget
                                                          .songNameTextStyle ??
                                                      audioNameTextStyle)))
                                    ])),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _artistController,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                          child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                  widget.model[index]
                                                          .artistName ??
                                                      '',
                                                  style: widget
                                                          .artistNameTextStyle ??
                                                      artistNameTextStyle)))
                                    ])),
                            sizedBoxGapConstantH10,
                            SliderTheme(
                                data: widget.sliderTheme ?? timeStampSlider,
                                child: Slider(
                                    value: sliderPosition ?? 0,
                                    min: 0,
                                    max: sliderMaxPosition ?? 0,
                                    onChanged: (value) {
                                      sliderPosition = value;
                                    },
                                    onChangeEnd: (value) {
                                      seekTo(value);
                                    })),
                            Padding(
                                padding: padding10,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          formatDuration(
                                              audioTimestamp ?? Duration.zero),
                                          style: timestampTextStyle),
                                      Text(
                                          formatDuration(
                                              (audioDuration ?? Duration.zero) -
                                                  (audioTimestamp ??
                                                      Duration.zero)),
                                          style: timestampTextStyle)
                                    ])),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  IconButton(
                                      onPressed: onSkipPrevious,
                                      icon: skipPrevIcon,
                                      style: widget.iconStyle ??
                                          secondaryIconStyle),
                                  IconButton.filled(
                                      onPressed: widget.onPressed ??
                                          () {
                                            setState(() {
                                              (player.state.name == 'playing')
                                                  ? pauseAudio()
                                                  : resumeAudio();
                                            });
                                          },
                                      icon: widget.icon ??
                                          Icon(player.state.name == 'playing'
                                              ? Icons.pause
                                              : Icons.play_arrow),
                                      style:
                                          widget.iconStyle ?? primaryIconStyle),
                                  IconButton(
                                      onPressed: onSkipNext,
                                      icon: skipNextIcon,
                                      style: widget.iconStyle ??
                                          secondaryIconStyle)
                                ])
                          ]))
                    ]))));
  }
}
