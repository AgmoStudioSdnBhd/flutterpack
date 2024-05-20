import 'package:flutter/cupertino.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

/// The listing repository. This repository is to map the data into model.
class ListingRepository extends ChangeNotifier {

  /// Map the audio json data to the audio model. This method
  /// is delayed for 2 seconds to avoid data loss
  Future<List<AudioModel>?> getAudioList(List? audio) async {
    await Future.delayed(sec5);
    return audio?.map((item) => AudioModel.fromJson(item)).toList();
  }

  /// Map the video json data to the video model. This method
  /// is delayed for 2 seconds to avoid data loss
  Future<List<VideoModel>?> getVideoList(List? video) async {
    await Future.delayed(sec5);
    return video?.map((item) => VideoModel.fromJson(item)).toList();
  }

  /// Map the image json data to the image model. This method
  /// is delayed for 2 seconds to avoid data loss
  Future<List<ImageModel>?> getImageList(List? image) async {
    await Future.delayed(sec5);
    return image?.map((item) => ImageModel.fromJson(item)).toList();
  }
}
