import 'package:flutter/material.dart';
import 'package:multimedia_gallery/src/listing/repository/image_repository.dart';

class ImageViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<bool> downloadImage(String imageUrl) async {
    final downloadResult = await ImageRepository().downloadImage(imageUrl);
    return downloadResult;
  }
}
