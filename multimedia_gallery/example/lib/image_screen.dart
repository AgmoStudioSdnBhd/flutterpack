import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageList = [
      mockAssetImageModel,
      mockImageModel,
    ];

    return Scaffold(
        body: ImageViewer(model: imageList));
  }
}
