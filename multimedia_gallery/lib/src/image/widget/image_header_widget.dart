import 'package:flutter/material.dart';
import 'package:multimedia_gallery/src/extension/extension.dart';

/// Image viewer app bar. Consist of date, time and image name.
/// This widget also include device dark mode detection for different UI.
class ImageHeader extends StatelessWidget {
  const ImageHeader(
      {super.key,
      required this.dateTime,
      required this.name,
      required this.isDarkMode,
      required this.onPressed});

  final DateTime dateTime;
  final String name;
  final bool isDarkMode;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
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
          ]),
    );
  }
}
