import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_gallery/src/extension/extension.dart';
import 'package:multimedia_gallery/src/image/widget/custom_indicator.dart';
import 'package:multimedia_gallery/src/image/widget/image_header_widget.dart';
import 'package:multimedia_gallery/src/listing/model/image_model.dart';
import 'package:multimedia_gallery/src/listing/viewmodel/image_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// The image viewer class. This class can be used to display image that can
/// be zoom in and out and panning. This class also detect the color mode of
/// the device for different UI.
/// Required: [model]

class ImageViewer extends StatelessWidget {
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
  final List<ImageModel>? model;

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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ImageViewModel(),
        child: _ImageViewer(
            model: model,
            key: key,
            appBar: appBar,
            fit: fit,
            radius: radius,
            indicatorHeight: indicatorHeight,
            opacity: opacity,
            alignment: alignment,
            repeat: repeat,
            frameLoadedBuilder: frameLoadedBuilder,
            frameLoadingBuilder: frameLoadingBuilder,
            boundaryMargin: boundaryMargin,
            clipBehaviour: clipBehaviour,
            constrained: constrained,
            maxScale: maxScale,
            minScale: minScale,
            onInteractionEnd: onInteractionEnd,
            onInteractionStart: onInteractionStart,
            onInteractionUpdate: onInteractionUpdate,
            panEnabled: panEnabled,
            scaleEnabled: scaleEnabled,
            transformationController: transformationController,
            width: width,
            height: height));
  }
}

class _ImageViewer extends StatefulWidget {
  const _ImageViewer(
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

  final List<ImageModel>? model;
  final BorderRadius? radius;
  final AppBar? appBar;
  final BoxFit? fit;
  final double? indicatorHeight;
  final Animation<double>? opacity;
  final ImageRepeat? repeat;
  final Alignment? alignment;
  final ImageFrameBuilder? frameLoadedBuilder;
  final ImageLoadingBuilder? frameLoadingBuilder;
  final EdgeInsets? boundaryMargin;
  final Clip? clipBehaviour;
  final bool? constrained;
  final double? minScale;
  final double? maxScale;
  final GestureScaleEndCallback? onInteractionEnd;
  final GestureScaleStartCallback? onInteractionStart;
  final GestureScaleUpdateCallback? onInteractionUpdate;
  final bool? panEnabled;
  final bool? scaleEnabled;
  final TransformationController? transformationController;
  final double? width;
  final double? height;

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> with WidgetsBindingObserver {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addObserver(this);
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _pageController.page;
    if (page != null) {
      setState(() {
        context.read<ImageViewModel>().setCurrentIndex(page.round());
      });
    }
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
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    final models = widget.model ?? [];
    DateTime dateTime =
        DateTime.tryParse(models[context.read<ImageViewModel>().currentIndex].uploadedDate ?? '')?.toLocal() ??
            DateTime.now();

    return OrientationBuilder(builder: (context, orientation) {
      final isPortrait = orientation == Orientation.portrait;
      return Container(
          color: isDarkMode ? Colors.black : Colors.white,
          child: SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: widget.appBar ?? buildAppBarView(models, isDarkMode, dateTime),
                  body: Column(children: [
                    Expanded(
                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: models.length,
                            itemBuilder: (context, index) {
                              final model = models[index];
                              return GestureDetector(
                                  onLongPress: () => model.path != null && model.path!.startsWith('http')
                                      ? _showDownloadDialog(model.path!)
                                      : null,
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
                                          image: getImageSourceType(model.path ?? ''),
                                          fit: widget.fit ?? (isPortrait ? BoxFit.fitWidth : BoxFit.fitHeight),
                                          width: widget.width ?? MediaQuery.of(context).size.width,
                                          height: widget.height ?? MediaQuery.of(context).size.height,
                                          opacity: widget.opacity,
                                          repeat: widget.repeat ?? ImageRepeat.noRepeat,
                                          frameBuilder: widget.frameLoadedBuilder ??
                                              (context, child, frame, wasSynchronouslyLoaded) => child,
                                          loadingBuilder: widget.frameLoadingBuilder ??
                                              (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return Center(
                                                    child: SizedBox(
                                                        height: widget.indicatorHeight ??
                                                            MediaQuery.of(context).size.height / 4,
                                                        child: CircularProgressIndicator(
                                                            value: loadingProgress.expectedTotalBytes != null
                                                                ? loadingProgress.cumulativeBytesLoaded /
                                                                    loadingProgress.expectedTotalBytes!
                                                                : null)));
                                              })));
                            })),
                    if (models.length > 1) buildIndicatorView(models, isDarkMode)
                  ]))));
    });
  }

  PreferredSizeWidget buildAppBarView(List<ImageModel> models, bool isDarkMode, DateTime dateTime) {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        flexibleSpace: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: imageHeader(dateTime, models[context.read<ImageViewModel>().currentIndex].name ?? '', isDarkMode,
                () => Navigator.pop(context))));
  }

  Widget buildIndicatorView(List<ImageModel> models, bool isDarkMode) {
    return Padding(
        padding: padding16,
        child: CustomIndicator(
            count: models.length,
            currentIndex: context.read<ImageViewModel>().currentIndex,
            activeColor: isDarkMode ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8),
            inactiveColor: Colors.grey.withOpacity(0.6),
            spacing: indicatorSpacing,
            size: indicatorSize));
  }

  void _showDownloadDialog(String imageUrl) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              title: const Text('Download Image', style: imageViewerDialogTitleTextStyle),
              content: const Text('Do you want to download this image?', style: imageViewerDialogSubTitleTextStyle),
              actions: <Widget>[
                TextButton(
                    child: const Text('Cancel', style: imageViewerDialogButtonTextStyle),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    }),
                TextButton(
                    child: const Text('Download', style: imageViewerDialogButtonTextStyle),
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      final isSuccess = await context.read<ImageViewModel>().downloadImage(imageUrl);
                      final message = isSuccess ? 'Your photo has been downloaded.' : 'Failed to save image';
                      _showDownloadSnackBar(message: message, imagePath: imageUrl);
                    })
              ]);
        });
  }

  void _showDownloadSnackBar({required String message, required String imagePath}) {
    final snackBar = SnackBar(
        content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(message, overflow: TextOverflow.ellipsis, style: snackBarTitleTextStyle)),
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _viewImage(context, imagePath);
              },
              child: const Text('VIEW', style: imageViewerDialogTextStyle))
        ]),
        backgroundColor: mainListingBlue,
        behavior: SnackBarBehavior.floating,
        shape: snackBarShapeStyle,
        duration: sec5);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _viewImage(context, String imagePath) async {
    if (Platform.isAndroid) {
      AndroidIntent intent =
          AndroidIntent(action: 'action_view', type: 'image/*', data: imagePath, flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
      await intent.launch();
    } else if (Platform.isIOS) {
      final bool isAppOpen = await launchUrl(Uri.parse("photos-redirect://"));
      if (!isAppOpen) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to open gallery')));
      }
    }
  }
}
