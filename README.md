# Multimedia Gallery

## Introduction

A gallery that support image, video and audio with presentable user interface.

## Features

List of features' supported platform
| Features | iOS | Android |
|--------------|--------------------|--------------------|
| Image Viewer | ✅ |✅|
| Video Viewer | ✅ |✅|
| Audio Viewer | ✅ |✅|
| Image List |✅|✅|
| Video List |✅|✅|
| Audio List |✅|✅|
| Next audio | ✅ |✅|
| Next video |✅|✅|
| Next image |❌|❌|

### Main Listing

This feature support the display of image list, video list and audio list. Also support the on press to display the media viewer.

<img src="multimedia_gallery/assets/images/listing.gif" width="400">

### Image Viewer

This feature support image panning, zoom in and out by pinching the image. This feature also supports for light mode and dark mode detector.
This feature support long press download image. Also showing indicator when there is multiple image in the list.

<img src="multimedia_gallery/assets/images/image_viewer_example.gif" alt="drawing" width="200"/>
<img src="multimedia_gallery/assets/images/image_viewer_dark_mode_example.gif" alt="drawing" width="200"/>

### Video Viewer

This feature support both device orientation with different user interface.

It also include:

- Play video: Able to play and resume video
- Pause video: Able to pause the video
- Duration slider: Able to slide the video to desire timestamp
- Next and Previous video: Able to press skip next or skip previous button to proceed to next and previous video.
- Replay video: Able to replay the video after the video is done playing.

  ![Image Viewer Example](multimedia_gallery/assets/images/play_pause_video_example.gif)
  ![Image Viewer Example](multimedia_gallery/assets/images/slider_example.gif)

### Audio Viewer

This feature include play, pause and seek certain timestamp with presentable user interface.

This feature is also supporting skip to next audio.

https://github.com/AgmoStudioSdnBhd/flutterpack/assets/164973699/6823591b-f8a4-4941-aa29-f6e63f69843d

Feature also include different user interface for different image file type

- Animated image

https://github.com/AgmoStudioSdnBhd/flutterpack/assets/164973699/75b8d71f-4bf9-4009-9264-91868c39757c

- Normal image

https://github.com/AgmoStudioSdnBhd/flutterpack/assets/164973699/371ad321-8945-421e-a106-b7f9e19d5fb4

### Requirements

- Flutter 3.7.0 or higher
- Dart 2.19.0 or higher.

### Usage

#### Main Listing

MainListing can be called to view the variety list of media by inputing the list of audio, image and video as shown in the example below. The parameter for the list is nullable. The required parameter for main listing are:

- List audioList
- List videoList
- List imageList

```import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

class Listing extends StatefulWidget {
  const Listing({super.key});

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  List audioRes = [];
  List videoRes = [];
  List imageRes = [];

  Future<List> readAudioFile() async {
    String audioList = await rootBundle.loadString('assets/asset/audio.json');
    final audioData = await jsonDecode(audioList);
    final audioJsonList = audioData["audio"];
    setState(() {
      audioRes = audioJsonList;
    });
    return audioRes;
  }

  Future<List> readVideoFile() async {
    String videoList = await rootBundle.loadString('assets/asset/video.json');
    final videoData = await jsonDecode(videoList);
    final videoJsonList = videoData["video"];
    setState(() {
      videoRes = videoJsonList;
    });
    return videoRes;
  }

  Future<List> readImageFile() async {
    String imageList = await rootBundle.loadString('assets/asset/image.json');
    final imageData = await jsonDecode(imageList);
    final imageJsonList = imageData["image"];
    setState(() {
      imageRes = imageJsonList;
    });
    return imageRes;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      readAudioFile();
      readVideoFile();
      readImageFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainListing(
        audioList: audioRes, videoList: videoRes, imageList: imageRes);
  }
}
```

#### Image Viewer

ImageViewer can be called to view image as shown below. The image path file type will be detected automatically. To use the image viewer, the required paramater is:

- Image model(path, uploadedDate, name)

**example/lib/image_screen.dart**

```
import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ImageViewer(
      model: ImageModel(
        path: 'assets/images/scenery.jpeg',
        uploadedDate: DateTime.now().toString(),
        name: 'Scenery',
      ),
    ));
  }
}

```

#### Video Viewer

VideoViewer can be called to view video as shown below. The video path is get using video model. The video path is detected automatically.
The required parameters are:

- VideoModel(path,name,uploadedDate)
- selected: The selected index from listing(if listing is used). Default value: 0.

**example/lib/video_screen.dart**

```
import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: VideoViewer(
      model: [
        VideoModel(
            path:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            name: 'Butterfly',
            uploadedDate: DateTime.now().toString())
      ],
      selected: 0,
    ));
  }
}

```

### Audio Viewer

AudioViewer can be called to view and listen to audio as shown below. The audio path file type is detect automatically.
The required parameter is:

- AudioModel(path, image, audioName, artistName)
- The selected index from listing(if listing is used). Default value: 0.

**example/lib/audio_screen.dart**

```
import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AudioViewer(
      model: [
        AudioModel(
          path: 'https://cdn.pixabay.com/audio/2024/03/16/audio_9a03ff5e94.mp3?filename=warm-nights-196465.mp3',
          image: 'assets/images/warm_nights.png',
          audioName: 'Warm Nights',
          artistName: 'xethrocc',
        )
      ],
      selectedIndex: 0,
    ));
  }
}
```
