import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_gallery/listing/main_listing.dart';

class Listing extends StatefulWidget {
  const Listing({super.key});

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  List audioRes = [];
  List videoRes = [];
  List imageRes = [];

  Future<List> readAudioFile() async {
    String audioList = await rootBundle.loadString('assets/asset/audio.json');
    final audioData = await jsonDecode(audioList);
    final audioJsonList = audioData["audio"];
    setState(() {
      audioRes = audioJsonList;
    });
    return audioRes;
  }

  Future<List> readVideoFile() async {
    String videoList = await rootBundle.loadString('assets/asset/video.json');
    final videoData = await jsonDecode(videoList);
    final videoJsonList = videoData["video"];
    setState(() {
      videoRes = videoJsonList;
    });
    return videoRes;
  }

  Future<List> readImageFile() async {
    String imageList = await rootBundle.loadString('assets/asset/image.json');
    final imageData = await jsonDecode(imageList);
    final imageJsonList = imageData["image"];
    setState(() {
      imageRes = imageJsonList;
    });
    return imageRes;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      readAudioFile();
      readVideoFile();
      readImageFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainListing(
        audioList: audioRes, videoList: videoRes, imageList: imageRes);
  }
}
