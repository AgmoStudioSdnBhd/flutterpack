import 'package:flutter/material.dart';
import 'package:multimedia_gallery/image/image_viewer.dart';
import 'package:multimedia_gallery/listing/model/image_model.dart';

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
