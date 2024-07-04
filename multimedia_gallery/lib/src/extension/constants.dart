import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';
import 'package:skeletonizer/skeletonizer.dart';

///Empty image
const AssetImage emptyImage = AssetImage('');

/// constant text style for the multimedia gallery
const TextStyle imageDateTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle imageTimeAndNameTextStyle = TextStyle(fontSize: 16);
const TextStyle audioNameTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
const TextStyle artistNameTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white70);
const TextStyle timestampTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
const TextStyle listingTitleTextStyle = TextStyle(color: Colors.white70, fontWeight: FontWeight.w800);

/// constant loading indicator
Widget loadingIndicator() => const Center(
    child: SizedBox(
        height: 40,
        child: LoadingIndicator(
            indicatorType: Indicator.lineScaleParty,
            backgroundColor: Colors.transparent,
            colors: [lightVibrantBlue],
            pathBackgroundColor: Colors.white38)));

/// gap constant
const SizedBox sizedBoxGapConstantH8 = SizedBox(height: 8);
const SizedBox sizedBoxGapConstantH10 = SizedBox(height: 10);
const SizedBox sizedBoxGapConstantW50 = SizedBox(width: 50);

/// constant padding
const EdgeInsets padding16 = EdgeInsets.all(16);
const EdgeInsets padding10 = EdgeInsets.all(10);
const EdgeInsets padding6 = EdgeInsets.all(6);

/// audio icon button style
const ButtonStyle primaryIconStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
    iconColor: WidgetStatePropertyAll<Color>(Colors.black),
    iconSize: WidgetStatePropertyAll(30));
const ButtonStyle secondaryIconStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll<Color>(Colors.transparent),
    iconColor: WidgetStatePropertyAll<Color>(Colors.white70),
    iconSize: WidgetStatePropertyAll(30));

/// constant gradient color
const Color lightVibrantBlue = Color.fromRGBO(197, 231, 255, 1.0);
const Color lightMutedBlue = Color.fromRGBO(88, 130, 159, 1.0);
const Color mainListingBlack = Color.fromARGB(255, 3, 14, 28);
const Color mainListingBlue = Color.fromARGB(255, 36, 52, 74);

/// constant back button
const Icon backButton = Icon(Icons.arrow_back);
const Icon skipPrevIcon = Icon(Icons.skip_previous);
const Icon skipNextIcon = Icon(Icons.skip_next);
const Icon pauseIcon = Icon(Icons.pause);
const Icon playIcon = Icon(Icons.play_arrow);
const Icon replayIcon = Icon(Icons.replay);
const Icon photoLibIcon = Icon(Icons.photo_library);
const Icon videoLibIcon = Icon(Icons.video_library);
const Icon musicLibIcon = Icon(Icons.library_music);

/// constant video aspect ratio
const double videoAspectRatio = 16 / 9;

/// constant timestamp style
SliderThemeData timeStampSlider = SliderThemeData(
    overlayShape: SliderComponentShape.noThumb,
    thumbColor: Colors.white,
    activeTrackColor: Colors.white,
    inactiveTrackColor: Colors.grey.withOpacity(0.6));

const LinearGradient activeIconGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [mainListingBlue, Color.fromARGB(255, 107, 192, 255)]);

///constant duration
const Duration sec2 = Duration(seconds: 2);
const Duration sec5 = Duration(seconds: 5);
const Duration sec10 = Duration(seconds: 10);
const Duration sec12 = Duration(seconds: 12);

///constant box decoration
const BoxDecoration listingBackgroundStyle = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [mainListingBlack, mainListingBlue]));
BoxDecoration activeNavIconStyle = BoxDecoration(borderRadius: BorderRadius.circular(50), gradient: activeIconGradient);

///constant image model
final mockImageModel = ImageModel(
    path:
        "https://images.unsplash.com/photo-1587869776358-66c797a206fb?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    name: "Scenery",
    uploadedDate: "2024-04-23 03:01:36.913664Z");
final mockVideoModel = VideoModel(
    path: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    name: BoneMock.name,
    uploadedDate: BoneMock.date);
final mockAudioModel = AudioModel(
    image: "assets/images/beach.gif",
    path: "https://cdn.pixabay.com/audio/2023/07/30/audio_4167bdd0fd.mp3",
    artistName: BoneMock.name,
    audioName: BoneMock.name);
