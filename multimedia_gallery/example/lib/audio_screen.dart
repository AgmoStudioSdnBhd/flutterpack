import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AudioViewer(
            path: assetFile('audio/Afterthought.mp3'),
            image: const AssetImage('assets/images/joji.png'),
            songName: 'Afterthought',
            artistName: 'Joji, BENEE'));
  }
}
