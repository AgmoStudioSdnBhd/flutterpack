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

### Image Viewer

This feature support image panning, zoom in and out by pinching the image. This feature also supports for light mode and dark mode detector.

<img src="multimedia_gallery/assets/images/image_viewer_example.gif" alt="drawing" width="200"/>
<img src="multimedia_gallery/assets/images/image_viewer_dark_mode_example.gif" alt="drawing" width="200"/>

### Video Viewer

This feature support both device orientation with different user interface.

It also include:

- Play video: Able to play and resume video
- Pause video: Able to pause the video
- Duration slider: Able to slide the video to desire timestamp

  ![Image Viewer Example](multimedia_gallery/assets/images/play_pause_video_example.gif)
  ![Image Viewer Example](multimedia_gallery/assets/images/slider_example.gif)

### Audio Viewer

This feature include play, pause and seek certain timestamp with presentable user interface.

Feature also include different user interface for different image file type

- Animated image

  <video src="multimedia_gallery/assets/videos/gif_audio_viewer_example.mov" height="400" controls="1"></video>

- Normal image

  <video src="multimedia_gallery/assets/videos/image_audio_viewer_example.mov" height="400" controls="1"></video>

### Requirements

- Flutter 3.7.0 or higher
- Dart 2.19.0 or higher.

### Usage

#### Image Viewer

ImageViewer can be called to view image as shown below. The image path is get via Image Provider. The image name and date time of the image capture will be required to call the method.

**example/lib/image_screen.dart**

```
import 'package:flutter/material.dart';
import 'package:multimedia_gallery/image/image_viewer.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ImageViewer(
            imageProvider: const AssetImage('assets/images/scenery.jpeg'),
            dateTime: DateTime.now(),
            name: 'Scenery'));
  }
}
```

#### Video Viewer

VideoViewer can be called to view video as shown below. The video path is get via video file extension provided by the package. There are 3 different file type extension can be call by using:

- **_assetVideo()_** to call video from assets file
- **_localVideo()_** to get the video from local file.
- **_networkVideo()_** to get the video with network url.
  The video path will be required to call this method.

**example/lib/video_screen.dart**

```
/// calling [networkVideo] with network url
import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: VideoViewer(path: networkVideo('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')));
  }
}

/// calling [assetVideo] with asset video file
VideoViewer(path: assetVideo('assets/video/butterfly.mp4'))

/// calling [localVideo] with video file located in local directory
VideoViewer(path: localFile('C:/Users/user/documents/butterfly.mp4'))
```

### Audio Viewer

AudioViewer can be called to view and listen to audio as shown below. The audio path is get via audio file extension provided by the package. There are 3 different file type extension can be call by using:

- **_assetFile()_** to call audio from assets file
- **_localFile()_** to get the audio from local file.
- **_urlFile()_** to get the audio with network url.
  The audio path will be required to call this method.

**example/lib/audio_screen.dart**

```
///calling [urlFile] to play network audio
import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AudioViewer(
            path: urlFile('https://cdn.pixabay.com/audio/2024/03/16/audio_9a03ff5e94.mp3?filename=warm-nights-196465.mp3'),
            image: const AssetImage('assets/images/warm_nights.png'),
            songName: 'Warm Nights',
            artistName: 'xethrocc'));
  }
}


/// calling [assetFile] to play audio file located in assets
AudioViewer(
  path: assetFile('assets/video/warm-nights.mp3'),
  image: const AssetImage('assets/images/warm-nights.png'),
  songName: 'Warm Nights',
  artistName: 'xethrocc');

/// calling [localFile] to play audio file located in local directory
AudioViewer(
  path: localFile('C:/Users/user/video/warm-nights.mp3'),
  image: const AssetImage('assets/images/warm_nights.png'),
  songName: 'Warm Nights',
  artistName: 'xethrocc');
```
