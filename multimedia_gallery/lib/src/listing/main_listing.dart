import 'package:flutter/material.dart';
import 'package:multimedia_gallery/src/listing/widget/audio_card.dart';
import 'package:multimedia_gallery/src/listing/viewmodel/listing_view_model.dart';
import 'package:multimedia_gallery/src/listing/widget/bottom_nav_bar_item_widget.dart';
import 'package:multimedia_gallery/src/listing/widget/image_card.dart';
import 'package:multimedia_gallery/src/listing/widget/video_card.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';
import 'package:provider/provider.dart';

/// The main listing page. To display the audio list, image list
/// or video list according to the tab selected. This also define
/// the provider function to help process the data.
class MainListing extends StatelessWidget {
  const MainListing({
    super.key,
    this.audioList,
    this.imageList,
    this.videoList,
  });

  /// The audio list get from user.
  final List? audioList;
  /// The image list get from user.
  final List? imageList;
  /// The video list get from user.
  final List? videoList;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ListingViewModel(),
        child: _MainListing(
          audioList: audioList,
          videoList: videoList,
          imageList: imageList,
        ));
  }
}


class _MainListing extends StatefulWidget {
  const _MainListing({required this.audioList, this.imageList, required this.videoList});

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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchMedia() async {
    switch (type) {
      case ListingType.image:
        context.read<ListingViewModel>().fetchImage(widget.imageList);
      case ListingType.audio:
        context.read<ListingViewModel>().fetchAudio(widget.audioList);
      case ListingType.video:
        context.read<ListingViewModel>().fetchVideo(widget.videoList);
      default:
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
                title: Padding(padding: padding16, child: Text(type.localizeTitle(), style: listingTitleTextStyle))),
            bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                    type = ListingType.values[index];
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
                  List? fetchedList;
                  if (fetchedList != [] && snapshot.connectionState == ConnectionState.done) {
                    return Consumer<ListingViewModel>(builder: (context, mediaProvider, child) {
                      switch (selectedIndex) {
                        case 0:
                          fetchedList = mediaProvider.fetchedImage;
                          break;
                        case 1:
                          fetchedList = mediaProvider.fetchedVideo;
                          break;
                        case 2:
                          fetchedList = mediaProvider.fetchedAudio;
                          break;
                        default:
                          fetchedList = [];
                          break;
                      }
                      return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: type == ListingType.image ? Colors.transparent : Colors.white24),
                          child: type == ListingType.image
                              ? GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20),
                                  padding: padding10,
                                  itemCount: fetchedList?.length, // total number of items
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => ImageViewer(model: fetchedList?[index])));
                                        },
                                        child: fetchedList?.isNotEmpty ?? false
                                            ? ImageCard(model: fetchedList?[index])
                                            : Container(color: Colors.white24));
                                  })
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: fetchedList?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    switch (selectedIndex) {
                                      case 0:
                                        break;
                                      case 1:
                                        listWidget = GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => VideoViewer(
                                                      model: fetchedList as List<VideoModel>, selected: index)));
                                            },
                                            child: VideoCard(
                                                model: fetchedList?[index],
                                                isLast: index == (fetchedList?.length ?? 1) - 1));
                                        break;
                                      case 2:
                                        listWidget = GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => AudioViewer(
                                                      selectedIndex: index, model: fetchedList as List<AudioModel>)));
                                            },
                                            child: AudioCard(
                                                model: fetchedList?[index],
                                                isLast: index == (fetchedList?.length ?? 1) - 1));
                                        break;
                                    }
                                    return listWidget;
                                  }));
                    });
                  } else {
                    return loadingIndicator();
                  }
                })));
  }
}
