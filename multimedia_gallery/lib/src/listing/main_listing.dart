import 'package:flutter/material.dart';
import 'package:multimedia_gallery/src/listing/widget/audio_card.dart';
import 'package:multimedia_gallery/src/listing/viewmodel/listing_view_model.dart';
import 'package:multimedia_gallery/src/listing/widget/bottom_nav_bar_item_widget.dart';
import 'package:multimedia_gallery/src/listing/widget/image_card.dart';
import 'package:multimedia_gallery/src/listing/widget/video_card.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// The main listing page. To display the audio list, image list
/// or video list according to the tab selected. This also defines
/// the provider function to help process the data.
class MainListing extends StatelessWidget {
  const MainListing({
    super.key,
    this.audioList,
    this.imageList,
    this.videoList,
  });

  /// The audio list from the user.
  final List? audioList;

  /// The image list from the user.
  final List? imageList;

  /// The video list from the user.
  final List? videoList;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ListingViewModel(),
        child: _MainListing(
            audioList: audioList, videoList: videoList, imageList: imageList));
  }
}

class _MainListing extends StatefulWidget {
  const _MainListing(
      {required this.audioList, this.imageList, required this.videoList});

  final List? audioList;
  final List? imageList;
  final List? videoList;

  @override
  State<_MainListing> createState() => _MainListingState();
}

class _MainListingState extends State<_MainListing> {
  var type = ListingType.image;
  int selectedIndex = 0;
  Widget? listWidget;

  @override
  void initState() {
    super.initState();
    _fetchMedia();
  }

  Future<void> _fetchMedia() async {
    switch (type) {
      case ListingType.image:
        await context.read<ListingViewModel>().fetchImage(widget.imageList);
        break;
      case ListingType.audio:
        await context.read<ListingViewModel>().fetchAudio(widget.audioList);
        break;
      case ListingType.video:
        await context.read<ListingViewModel>().fetchVideo(widget.videoList);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: listingBackgroundStyle,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 20,
                backgroundColor: Colors.transparent,
                title: Padding(
                    padding: padding16,
                    child: Text(type.localizeTitle(),
                        style: listingTitleTextStyle))),
            bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                    type = ListingType.values[index];
                    _fetchMedia();
                  });
                },
                currentIndex: selectedIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: mainListingBlack,
                unselectedItemColor: Colors.white70,
                iconSize: 28,
                items: [
                  bottomNavBarItem(photoLibIcon),
                  bottomNavBarItem(videoLibIcon),
                  bottomNavBarItem(musicLibIcon)
                ]),
            body: FutureBuilder(
                future: _fetchMedia(),
                builder: (context, snapshot) {
                  return Consumer<ListingViewModel>(
                      builder: (context, mediaProvider, child) {
                    List? fetchedList;
                    switch (selectedIndex) {
                      case 0:
                        snapshot.connectionState == ConnectionState.waiting
                            ? fetchedList = List.filled(6, mockImageModel)
                            : fetchedList = mediaProvider.fetchedImage;
                        break;
                      case 1:
                        snapshot.connectionState == ConnectionState.waiting
                            ? fetchedList = List.filled(6, mockVideoModel)
                            : fetchedList = mediaProvider.fetchedVideo;
                        break;
                      case 2:
                        snapshot.connectionState == ConnectionState.waiting
                            ? fetchedList = List.filled(6, mockAudioModel)
                            : fetchedList = mediaProvider.fetchedAudio;
                        break;
                      default:
                        fetchedList = [];
                        break;
                    }
                    return Skeletonizer(
                        enabled:
                            snapshot.connectionState == ConnectionState.waiting,
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: type == ListingType.image
                                    ? Colors.transparent
                                    : Colors.white24),
                            child: type == ListingType.image
                                ? GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 20,
                                            crossAxisSpacing: 20),
                                    padding: padding10,
                                    itemCount: fetchedList?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageViewer(
                                                            model: fetchedList?[
                                                                        index]
                                                                    is ImageModel
                                                                ? fetchedList
                                                                    as List<
                                                                        ImageModel>
                                                                : List
                                                                    .empty())));
                                          },
                                          child: fetchedList?.isNotEmpty ??
                                                  false
                                              ? ImageCard(
                                                  model: fetchedList?[index])
                                              : Container(
                                                  color: Colors.white24));
                                    })
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: fetchedList?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      switch (selectedIndex) {
                                        case 1:
                                          listWidget = GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoViewer(
                                                                model: fetchedList
                                                                    as List<
                                                                        VideoModel>,
                                                                selected:
                                                                    index)));
                                              },
                                              child: VideoCard(
                                                  model: fetchedList?[index],
                                                  isLast: index ==
                                                      (fetchedList?.length ??
                                                              1) -
                                                          1));
                                          break;
                                        case 2:
                                          listWidget = GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AudioViewer(
                                                                selectedIndex:
                                                                    index,
                                                                model: fetchedList
                                                                    as List<
                                                                        AudioModel>)));
                                              },
                                              child: AudioCard(
                                                  model: fetchedList?[index],
                                                  isLast: index ==
                                                      (fetchedList?.length ??
                                                              1) -
                                                          1));
                                          break;
                                      }
                                      return listWidget;
                                    })));
                  });
                })));
  }
}
