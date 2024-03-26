import 'package:flutter/material.dart';
import 'package:multimedia_gallery/multimedia_gallery.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AudioViewer(
            path: urlFile(
                'https://cdn.pixabay.com/audio/2024/03/16/audio_9a03ff5e94.mp3?filename=warm-nights-196465.mp3'),
            image: const AssetImage('assets/images/warm_nights.png'),
            songName: 'Warm Nights',
            artistName: 'xethrocc'));
  }
}
