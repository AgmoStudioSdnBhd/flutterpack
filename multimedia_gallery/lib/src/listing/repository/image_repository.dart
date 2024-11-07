import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class ImageRepository extends ChangeNotifier {
  Future<bool> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    final result = await ImageGallerySaverPlus.saveImage(Uint8List.fromList(bytes));
    return result['isSuccess'];
  }
}
