import 'package:flutter/material.dart';
import 'package:multimedia_gallery/extension/image_file_ext.dart';
import 'package:multimedia_gallery/listing/model/image_model.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.model});

  final ImageModel model;

  @override
  Widget build(BuildContext context) {
    ImageProvider img = getImageSourceType(model.path ?? '');
    return model.path != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(6),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image(
                image: img,
                fit: BoxFit.cover,
                width: 20,
                height: 20,
                filterQuality: FilterQuality.high))
        : Container(color: Colors.white24);
  }
}
