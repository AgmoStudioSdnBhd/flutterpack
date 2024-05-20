import 'package:flutter/material.dart';
import 'package:multimedia_gallery/src/extension/extension.dart';
import 'package:multimedia_gallery/src/listing/model/image_model.dart';

/// The image card. To show the image on the listing.
class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.model});

  /// The image model. To display image data in listing
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
