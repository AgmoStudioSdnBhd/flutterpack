import 'package:flutter/material.dart';
import 'package:multimedia_gallery/extension/constants.dart';
import 'package:multimedia_gallery/extension/string_formatter.dart';

/// image viewer app bar. Consist of date, time and image name.
/// This widget also include device dark mode detection for different UI.
Widget imageHeader(DateTime dateTime, String name, bool isDarkMode,
    void Function() onPressed) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            icon: backButton,
            onPressed: onPressed,
            color: isDarkMode ? Colors.white : Colors.black),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formatDateToyMMMd(dateTime),
                  style: imageDateTextStyle.merge(TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black))),
              Row(children: [
                Text(formatTimeWithImageName(dateTime, name),
                    style: imageTimeAndNameTextStyle.merge(TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black54)))
              ])
            ])
      ]);
}
