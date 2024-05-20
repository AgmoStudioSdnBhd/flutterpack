import 'package:flutter/foundation.dart';
import 'package:multimedia_gallery/src/listing/model/image_model.dart';
import 'package:multimedia_gallery/src/listing/model/video_model.dart';
import 'package:multimedia_gallery/src/listing/repository/listing_repo.dart';
import 'package:multimedia_gallery/src/listing/model/audio_model.dart';

class ListingViewModel extends ChangeNotifier {
  /// The fetched audio list. Can get the audio list after [fetchAudio].
  List<AudioModel>? fetchedAudio;

  /// The fetched audio list. Can get the audio list after [fetchVideo].
  List<VideoModel>? fetchedVideo;

  /// The fetched audio list. Can get the audio list after [fetchImage].
  List<ImageModel>? fetchedImage;

  /// To fetch audio from repository by [getAudioList] and notify the
  /// state of the [fetchedAudio]
  Future<void> fetchAudio(List? audio) async {
    fetchedAudio = await ListingRepository().getAudioList(audio);
    notifyListeners();
  }

  /// To fetch video from repository by [getVideoList] and notify the
  /// state of the [fetchedVideo]
  Future<void> fetchVideo(List? video) async {
    fetchedVideo = await ListingRepository().getVideoList(video);
    notifyListeners();
  }

  /// To fetch image from repository by [getImageList] and notify the
  /// state of the [fetchedImage]
  Future<void> fetchImage(List? image) async {
    fetchedImage = await ListingRepository().getImageList(image);
    notifyListeners();
  }
}
