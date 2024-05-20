import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

/// The constant bottom navigation bar item
BottomNavigationBarItem bottomNavBarItem(Icon navIcon) {
  return BottomNavigationBarItem(
      icon: navIcon,
      label: ' ',
      activeIcon: Container(
          width: 60,
          height: 60,
          decoration: activeNavIconStyle,
          child: Icon(navIcon.icon, color: Colors.white70)));
}
