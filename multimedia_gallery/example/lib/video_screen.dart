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
