import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:multimedia_gallery/extension/constants.dart';

/// The timestamp text format. The timestamp text show below the slider is format to two digits
/// for second and one digit for minutes.
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String minutes = duration.inMinutes.remainder(60).toString();
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$twoDigitSeconds';
}

/// The image header formatter.
String formatTimeWithImageName(DateTime dt, String name) {
  String time = DateFormat.Hm().format(dt);
  return '$time | $name';
}

/// The date formatter. Format date to (MMMM d,yyyy)
String formatDateToyMMMd(DateTime dt) => DateFormat.yMMMMd('en_US').format(dt);

/// The video timestamp formatter.
String formatVideoDuration(String current, String dur) => '$current / $dur';

bool isGif(ImageProvider? image) => (image ?? emptyImage).toString().contains('.gif');
