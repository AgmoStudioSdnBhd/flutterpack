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
