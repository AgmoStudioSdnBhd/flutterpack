import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageRepository extends ChangeNotifier {
  Future<bool> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
    return result['isSuccess'];
  }
}
