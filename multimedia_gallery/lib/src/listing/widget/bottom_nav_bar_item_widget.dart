import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

BottomNavigationBarItem bottomNavBarItem(Icon navIcon, Icon activeNavIcon) {
  return BottomNavigationBarItem(
      icon: navIcon,
      label: ' ',
      activeIcon: Container(
          width: 60,
          height: 60,
          decoration: activeNavIconStyle,
          child: const Icon(Icons.photo_library, color: Colors.white70)));
}
