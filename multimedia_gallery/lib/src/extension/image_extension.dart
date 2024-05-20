import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// The image source assign method. To automatically assign the image source.
getImageSourceType(String? path) {
  if (path != null) {
    if (path.startsWith('https') || path.startsWith('http')) {
      return NetworkImage(path);
    } else if (path.startsWith('assets')) {
      return AssetImage(path);
    } else {
      Uint8List bytes = base64Decode(path);
      return MemoryImage(bytes);
    }
  }
}

/// The gif image detector. To detect gif and display UI accordingly.
bool isGif(String path) {
  ImageProvider img = getImageSourceType(path);
  if (img.toString().contains('.gif')) {
    return true;
  } else if (img is MemoryImage) {
    return (img.bytes.length >= 6 &&
            img.bytes[0] == 0x47 &&
            img.bytes[1] == 0x49 &&
            img.bytes[2] == 0x46 &&
            (img.bytes[3] == 0x38 &&
                (img.bytes[4] == 0x39 || img.bytes[4] == 0x37)) &&
            img.bytes[5] == 0x61) ||
        (img.toString().contains('.gif'));
  } else {
    return false;
  }
}
