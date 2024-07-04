import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_gallery/src/extension/extension.dart';
import 'package:multimedia_gallery/src/image/widget/image_header_widget.dart';
import 'package:multimedia_gallery/src/listing/model/image_model.dart';

/// The image viewer class. This class can be used to display image that can
/// be zoom in and out and panning. This class also detect the color mode of
/// the device for different UI.
/// Required: [model]
class ImageViewer extends StatefulWidget {
  const ImageViewer(
      {super.key,
      required this.model,
      this.appBar,
      this.fit,
      this.radius,
      this.indicatorHeight,
      this.opacity,
      this.alignment,
      this.repeat,
      this.frameLoadedBuilder,
      this.frameLoadingBuilder,
      this.boundaryMargin,
      this.clipBehaviour,
      this.constrained,
      this.maxScale,
      this.minScale,
      this.onInteractionEnd,
      this.onInteractionStart,
      this.onInteractionUpdate,
      this.panEnabled,
      this.scaleEnabled,
      this.transformationController,
      this.width,
      this.height});

  /// The image model.
  final ImageModel model;

  /// The image border radius.
  final BorderRadius? radius;

  final AppBar? appBar;

  /// The image fit.
  final BoxFit? fit;

  /// The loading indicator height.
  final double? indicatorHeight;

  /// The image opacity.
  final Animation<double>? opacity;

  /// The image repeat.
  final ImageRepeat? repeat;

  /// The image alignment.
  final Alignment? alignment;

  /// The image loaded builder.
  final ImageFrameBuilder? frameLoadedBuilder;

  /// The image loading builder.
  final ImageLoadingBuilder? frameLoadingBuilder;

  /// The screen padding.
  final EdgeInsets? boundaryMargin;

  /// The image clip behaviour.
  final Clip? clipBehaviour;

  /// To constrained the image.
  final bool? constrained;

  /// The minimum scale to zoom in/out.
  /// Minimum index = [0.8]
  /// Default index = [1.0]
  final double? minScale;

  /// The maximum scale to zoom in/out.
  /// Minimum index = greater than [minScale] and 0.
  /// Default index = [3.0]
  final double? maxScale;

  /// The interaction function. Will triggered when interaction is [end].
  final GestureScaleEndCallback? onInteractionEnd;

  /// The interaction function. Will triggered when interaction is [start].
  final GestureScaleStartCallback? onInteractionStart;

  /// The interaction function. Will triggered to [update].
  final GestureScaleUpdateCallback? onInteractionUpdate;

  /// To enable panning. Default: [false]
  final bool? panEnabled;

  /// To enable scaling gesture. Default: [true]
  final bool? scaleEnabled;

  /// To transform image according to the matrix. Eg: [Rotate]
  final TransformationController? transformationController;

  /// The image width.
  final double? width;

  /// The image height.
  final double? height;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    DateTime dateTime = DateTime.tryParse(widget.model.uploadedDate ?? '')?.toLocal() ?? DateTime.now();
    return OrientationBuilder(builder: (context, orientation) {
      final isPortrait = orientation == Orientation.portrait;
      return Container(
          color: isDarkMode ? Colors.black : Colors.white,
          child: SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: widget.appBar ??
                      AppBar(
                          automaticallyImplyLeading: false,
                          backgroundColor: isDarkMode ? Colors.black : Colors.white,
                          flexibleSpace:
                              imageHeader(dateTime, widget.model.name ?? '', isDarkMode, () => Navigator.pop(context))),
                  body: Center(
                      child: ClipRRect(
                          borderRadius: widget.radius ?? BorderRadius.zero,
                          child: InteractiveViewer(
                              transformationController: widget.transformationController,
                              boundaryMargin: widget.boundaryMargin ?? padding6,
                              clipBehavior: widget.clipBehaviour ?? Clip.hardEdge,
                              constrained: widget.constrained ?? true,
                              minScale: widget.minScale ?? 1,
                              maxScale: widget.maxScale ?? 3,
                              onInteractionEnd: widget.onInteractionEnd,
                              onInteractionStart: widget.onInteractionStart,
                              onInteractionUpdate: widget.onInteractionUpdate,
                              panEnabled: widget.panEnabled ?? false,
                              scaleEnabled: widget.scaleEnabled ?? true,
                              child: Image(
                                  image: getImageSourceType(widget.model.path ?? ''),
                                  fit: widget.fit ?? (isPortrait ? BoxFit.fitWidth : BoxFit.fitHeight),
                                  width: widget.width ?? MediaQuery.of(context).size.width,
                                  height: widget.height ?? MediaQuery.of(context).size.height,
                                  opacity: widget.opacity,
                                  repeat: widget.repeat ?? ImageRepeat.noRepeat,
                                  frameBuilder: widget.frameLoadedBuilder ??
                                      (context, child, frame, wasSynchronouslyLoaded) => child,
                                  loadingBuilder: widget.frameLoadingBuilder ??
                                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        return loadingProgress == null
                                            ? child
                                            : SizedBox(
                                                height:
                                                    widget.indicatorHeight ?? MediaQuery.of(context).size.height / 4,
                                                child: loadingIndicator());
                                      })))))));
    });
  }
}
