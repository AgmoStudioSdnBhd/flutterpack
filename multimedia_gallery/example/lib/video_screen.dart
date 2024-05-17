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
