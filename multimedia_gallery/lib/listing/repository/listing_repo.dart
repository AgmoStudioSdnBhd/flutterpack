import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:multimedia_gallery/listing/model/audio_model.dart';
import 'package:multimedia_gallery/listing/model/image_model.dart';
import 'package:multimedia_gallery/listing/model/video_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ListingRepository extends ChangeNotifier {
  Future<List<AudioModel>?> getAudioList(List? audio) async {
    await Future.delayed(const Duration(seconds: 1));
    return audio?.map((item) => AudioModel.fromJson(item)).toList();
  }

  Future<List<VideoModel>?> getVideoList(List? video) async {
    await Future.delayed(const Duration(seconds: 2));
    return video?.map((item) => VideoModel.fromJson(item)).toList();
  }

  Future<Uint8List> generateThumbnail(String path) async {
    String? thumbnailPath;
    final res = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: thumbnailPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 100,
    );
    final file = File(res ?? '');
    return file.readAsBytesSync();
  }

  Future<List<ImageModel>?> getImageList(List? image) async {
    await Future.delayed(const Duration(seconds: 2));
    return image?.map((item) => ImageModel.fromJson(item)).toList();
  }
}
