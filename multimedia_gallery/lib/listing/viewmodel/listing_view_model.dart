import 'package:flutter/foundation.dart';
import 'package:multimedia_gallery/listing/model/image_model.dart';
import 'package:multimedia_gallery/listing/model/video_model.dart';
import 'package:multimedia_gallery/listing/repository/listing_repo.dart';
import 'package:multimedia_gallery/listing/model/audio_model.dart';

class MediaProvider extends ChangeNotifier {
  List<AudioModel>? fetchedAudio;
  List<VideoModel>? fetchedVideo;
  List<ImageModel>? fetchedImage;
  Uint8List? thumbnailBytes;

  Future<void> fetchAudio(List? audio) async {
    fetchedAudio = await ListingRepository().getAudioList(audio);
    notifyListeners();
  }

  Future<void> fetchVideo(List? video) async {
    fetchedVideo = await ListingRepository().getVideoList(video);
    notifyListeners();
  }

  Future<void> fetchImage(List? image) async {
    fetchedImage = await ListingRepository().getImageList(image);
    notifyListeners();
  }

  Future<void> generateThumbnail(String path) async {
    thumbnailBytes = await ListingRepository().generateThumbnail(path);
    notifyListeners();
  }
}
