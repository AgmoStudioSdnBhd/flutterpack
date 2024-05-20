import 'package:flutter/material.dart';
import 'package:multimedia_gallery/src/extension/extension.dart';
import 'package:palette_generator/palette_generator.dart';

/// The gradient background class. This class object is define to use as
/// the gradient background by detecting the color palette of the image
/// and use two color getting from the color palette to use as backdrop gradient.
/// Required: [image], [child]
class GradientBackground extends StatefulWidget {
  const GradientBackground(
      {super.key, required this.image, required this.child});

  final ImageProvider image;
  final Widget child;


  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground> {
  List<Color> colorsList = [];
  PaletteGenerator? generator;

  @override
  void initState() {
    super.initState();
    getColorPalette();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getColorPalette();
  }

  @override
  void didUpdateWidget(covariant GradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    getColorPalette();
  }

  /// The color palette generator. This method is use to generate color palette
  /// from the given [image]
  Future<void> getColorPalette() async {
    generator = await PaletteGenerator.fromImageProvider(widget.image);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      generator?.darkMutedColor?.color ?? lightMutedBlue,
      generator?.vibrantColor?.color ?? lightVibrantBlue,
    ];

    return Scaffold(
        body: generator == null
            ? loadingIndicator()
            : Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: colors)),
                child: widget.child,
              ));
  }
}
