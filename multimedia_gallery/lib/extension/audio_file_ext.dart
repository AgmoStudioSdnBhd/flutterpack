import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

/// Playing network file. This method required to be used to call the network file path to be played.
/// Return using audioplayer file extension [UrlSource].
urlFile(String path) {
  return UrlSource(path);
}

/// Playing asset file. This method required to be used to call the asset file path to be played.
/// Return using audioplayer file extension [AssetSource].
/// Make sure assets path is define in pubspec.yaml
assetFile(String path) {
  return AssetSource(path);
}

/// Playing local file. This method required to be used to fetch for local file path to be played.
/// Return using audioplayer file extension [DeviceFileSource].
/// Access to the directories is required.
localFile(String path) {
  return DeviceFileSource(path);
}

getAudioSourceType(String? path) {
  if (path != null) {
    if (path.startsWith('https') || path.startsWith('http')) {
      return UrlSource(path);
    } else if (path.startsWith('assets')) {
      return AssetSource(path);
    } else {
      return BytesSource(path as Uint8List);
    }
  }
}
