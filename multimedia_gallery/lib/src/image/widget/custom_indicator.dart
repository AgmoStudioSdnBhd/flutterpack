import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double spacing;
  final double size;

  const CustomIndicator(
      {super.key,
      required this.count,
      required this.currentIndex,
      this.activeColor = Colors.black,
      this.inactiveColor = Colors.grey,
      this.spacing = 8.0,
      this.size = 10.0});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          bool isActive = index == currentIndex;
          return Container(
              width: size,
              height: size,
              margin: EdgeInsets.symmetric(horizontal: spacing / 2),
              decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? activeColor : inactiveColor));
        }));
  }
}
