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
  const ImageViewer({
    super.key,
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
    this.height,
    this.topSafeAreaEnabled = true,
    this.bottomSafeAreaEnabled = true,
    this.darkModeEnabled = true,
    this.overwriteUiMode = true,
    this.customUiMode,
    this.downloadDialogTitle = 'Download Image',
    this.downloadDialogDescription = 'Do you want to download this image?',
    this.downloadDialogPositiveButtonText = 'Download',
    this.downloadDialogNegativeButtonText = 'Cancel',
    this.downloadSuccessText = 'Your photo has been downloaded.',
    this.downloadFailedText = 'Failed to save image.',
    this.downloadToastButtonText = 'VIEW',
    this.openGalleryFailedText = 'Failed to open gallery.',
    this.downloadImageEnabled = true,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.indicatorActiveColor,
    this.indicatorInactiveColor,
  });

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

  /// To enable top safe area. Default: [true]
  final bool topSafeAreaEnabled;

  /// To enable bottom safe area. Default: [true]
  final bool bottomSafeAreaEnabled;

  /// To enable dark mode styles, if null, will use device brightness mode. Default: [null]
  final bool? darkModeEnabled;

  /// To enable the overwriting of system ui mode of the app. Default: [true]
  final bool overwriteUiMode;

  /// To overwrite existing system ui mode. Default: [SystemUiMode.immersiveSticky]
  final SystemUiMode? customUiMode;

  /// The title text of the download dialog. Default: ['Download Image']
  final String downloadDialogTitle;

  /// The description text of the download dialog. Default: ['Do you want to download this image?']
  final String downloadDialogDescription;

  /// The positive button text of the download dialog. Default: ['Download']
  final String downloadDialogPositiveButtonText;

  /// The negative button text of the download dialog. Default: ['Cancel']
  final String downloadDialogNegativeButtonText;

  /// The message displayed after download success. Default: ['Your photo has been downloaded.']
  final String downloadSuccessText;

  /// The message displayed after download failed. Default: ['Failed to save image.']
  final String downloadFailedText;

  /// The button text shown on the toast message after download successful. Default: ['VIEW']
  final String downloadToastButtonText;

  /// The message displayed after failed to open gallery. iOS only. Default: ['Failed to open gallery.']
  final String openGalleryFailedText;

  /// To enable download onLongPressed: Default: [true]
  final bool downloadImageEnabled;

  /// Background color, default to follow dark and light mode, black for dark mode, white for light mode
  final Color? backgroundColor;

  /// App bar background color, default to backgroundColor
  final Color? appBarBackgroundColor;

  /// Active indicator color, default to backgroundColor with opacity of 0.8
  final Color? indicatorActiveColor;

  /// Inactive indicator color, default to grey color
  final Color? indicatorInactiveColor;

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
          height: height,
          topSafeAreaEnabled: topSafeAreaEnabled,
          bottomSafeAreaEnabled: bottomSafeAreaEnabled,
          darkModeEnabled: darkModeEnabled,
          overwriteUiMode: overwriteUiMode,
          customUiMode: customUiMode,
          downloadDialogTitle: downloadDialogTitle,
          downloadDialogDescription: downloadDialogDescription,
          downloadDialogPositiveButtonText: downloadDialogPositiveButtonText,
          downloadDialogNegativeButtonText: downloadDialogNegativeButtonText,
          downloadSuccessText: downloadSuccessText,
          downloadFailedText: downloadFailedText,
          downloadToastButtonText: downloadToastButtonText,
          openGalleryFailedText: openGalleryFailedText,
          downloadImageEnabled: downloadImageEnabled,
          backgroundColor: backgroundColor,
          appBarBackgroundColor: appBarBackgroundColor,
          indicatorActiveColor: indicatorActiveColor,
          indicatorInactiveColor: indicatorInactiveColor,
        ));
  }
}

class _ImageViewer extends StatefulWidget {
  const _ImageViewer({
    super.key,
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
    this.height,
    this.topSafeAreaEnabled = true,
    this.bottomSafeAreaEnabled = true,
    this.darkModeEnabled,
    this.overwriteUiMode = true,
    this.customUiMode,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.indicatorActiveColor,
    this.indicatorInactiveColor,
    required this.downloadDialogTitle,
    required this.downloadDialogDescription,
    required this.downloadDialogPositiveButtonText,
    required this.downloadDialogNegativeButtonText,
    required this.downloadSuccessText,
    required this.downloadFailedText,
    required this.downloadToastButtonText,
    required this.openGalleryFailedText,
    required this.downloadImageEnabled,
  });

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
  final bool topSafeAreaEnabled;
  final bool bottomSafeAreaEnabled;
  final bool? darkModeEnabled;
  final bool overwriteUiMode;
  final SystemUiMode? customUiMode;
  final String downloadDialogTitle;
  final String downloadDialogDescription;
  final String downloadDialogPositiveButtonText;
  final String downloadDialogNegativeButtonText;
  final String downloadSuccessText;
  final String downloadFailedText;
  final String downloadToastButtonText;
  final String openGalleryFailedText;
  final bool downloadImageEnabled;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final Color? indicatorActiveColor;
  final Color? indicatorInactiveColor;

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer>
    with WidgetsBindingObserver {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.overwriteUiMode) {
      SystemChrome.setEnabledSystemUIMode(
          widget.customUiMode ?? SystemUiMode.immersiveSticky);
    }
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
        if (widget.overwriteUiMode) {
          SystemChrome.setEnabledSystemUIMode(
              widget.customUiMode ?? SystemUiMode.immersiveSticky);
        }
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
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = widget.darkModeEnabled ?? (brightness == Brightness.dark);

    final models = widget.model ?? [];
    DateTime dateTime = DateTime.tryParse(
        models[context.read<ImageViewModel>().currentIndex]
            .uploadedDate ??
            '')
        ?.toLocal() ??
        DateTime.now();

    final bgColor =
        widget.backgroundColor ?? (isDarkMode ? Colors.black : Colors.white);

    return OrientationBuilder(builder: (context, orientation) {
      final isPortrait = orientation == Orientation.portrait;
      return Container(
          color: bgColor,
          child: SafeArea(
              top: widget.topSafeAreaEnabled,
              bottom: widget.bottomSafeAreaEnabled,
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: widget.appBar ??
                      buildAppBarView(models, isDarkMode, dateTime,
                          widget.appBarBackgroundColor ?? bgColor),
                  body: Column(children: [
                    Expanded(
                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: models.length,
                            itemBuilder: (context, index) {
                              final model = models[index];
                              return GestureDetector(
                                  onLongPress: widget.downloadImageEnabled
                                      ? () => model.path != null &&
                                      model.path!.startsWith('http')
                                      ? _showDownloadDialog(model.path!)
                                      : null
                                      : null,
                                  child: InteractiveViewer(
                                      transformationController:
                                      widget.transformationController,
                                      boundaryMargin:
                                      widget.boundaryMargin ?? padding6,
                                      clipBehavior:
                                      widget.clipBehaviour ?? Clip.hardEdge,
                                      constrained: widget.constrained ?? true,
                                      minScale: widget.minScale ?? 1,
                                      maxScale: widget.maxScale ?? 3,
                                      onInteractionEnd: widget.onInteractionEnd,
                                      onInteractionStart:
                                      widget.onInteractionStart,
                                      onInteractionUpdate:
                                      widget.onInteractionUpdate,
                                      panEnabled: widget.panEnabled ?? false,
                                      scaleEnabled: widget.scaleEnabled ?? true,
                                      child: Image(
                                          image: getImageSourceType(
                                              model.path ?? ''),
                                          fit: widget.fit ??
                                              (isPortrait
                                                  ? BoxFit.fitWidth
                                                  : BoxFit.fitHeight),
                                          width: widget.width ??
                                              MediaQuery.of(context).size.width,
                                          height: widget.height ??
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          opacity: widget.opacity,
                                          repeat: widget.repeat ??
                                              ImageRepeat.noRepeat,
                                          frameBuilder: widget
                                              .frameLoadedBuilder ??
                                                  (context, child, frame,
                                                  wasSynchronouslyLoaded) =>
                                              child,
                                          loadingBuilder: widget
                                              .frameLoadingBuilder ??
                                                  (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                    child: SizedBox(
                                                        height: widget
                                                            .indicatorHeight ??
                                                            MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height /
                                                                4,
                                                        child: CircularProgressIndicator(
                                                            value: loadingProgress
                                                                .expectedTotalBytes !=
                                                                null
                                                                ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                                : null)));
                                              })));
                            })),
                    if (models.length > 1)
                      buildIndicatorView(models, isDarkMode)
                  ]))));
    });
  }

  PreferredSizeWidget buildAppBarView(List<ImageModel> models, bool isDarkMode,
      DateTime dateTime, Color backgroundColor) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      flexibleSpace: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ImageHeader(
          dateTime: dateTime,
          name: models[context.read<ImageViewModel>().currentIndex].name ?? '',
          isDarkMode: isDarkMode,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget buildIndicatorView(List<ImageModel> models, bool isDarkMode) {
    return Padding(
        padding: padding16,
        child: CustomIndicator(
            count: models.length,
            currentIndex: context.read<ImageViewModel>().currentIndex,
            activeColor: widget.indicatorActiveColor ??
                (isDarkMode
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.8)),
            inactiveColor:
            widget.indicatorInactiveColor ?? Colors.grey.withOpacity(0.6),
            spacing: indicatorSpacing,
            size: indicatorSize));
  }

  void _showDownloadDialog(String imageUrl) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              title: Text(widget.downloadDialogTitle,
                  style: imageViewerDialogTitleTextStyle),
              content: Text(widget.downloadDialogDescription,
                  style: imageViewerDialogSubTitleTextStyle),
              actions: <Widget>[
                TextButton(
                    child: Text(widget.downloadDialogNegativeButtonText,
                        style: imageViewerDialogButtonTextStyle),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    }),
                TextButton(
                    child: Text(widget.downloadDialogPositiveButtonText,
                        style: imageViewerDialogButtonTextStyle),
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      final isSuccess = await context
                          .read<ImageViewModel>()
                          .downloadImage(imageUrl);
                      final message = isSuccess
                          ? widget.downloadSuccessText
                          : widget.downloadFailedText;
                      _showDownloadSnackBar(
                          message: message, imagePath: imageUrl);
                    })
              ]);
        });
  }

  void _showDownloadSnackBar(
      {required String message, required String imagePath}) {
    final snackBar = SnackBar(
        content:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(message,
                  overflow: TextOverflow.ellipsis,
                  style: snackBarTitleTextStyle)),
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _viewImage(context, imagePath);
              },
              child: Text(widget.downloadToastButtonText,
                  style: imageViewerDialogTextStyle))
        ]),
        backgroundColor: mainListingBlue,
        behavior: SnackBarBehavior.floating,
        shape: snackBarShapeStyle,
        duration: sec5);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _viewImage(context, String imagePath) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          type: 'image/*',
          data: imagePath,
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
      await intent.launch();
    } else if (Platform.isIOS) {
      final bool isAppOpen = await launchUrl(Uri.parse("photos-redirect://"));
      if (!isAppOpen) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.openGalleryFailedText)));
      }
    }
  }
}
