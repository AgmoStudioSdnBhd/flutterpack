import 'package:example/audio_screen.dart';
import 'package:example/image_screen.dart';
import 'package:example/listing.dart';
import 'package:example/video_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title: "App", home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Multimedia Gallery Demo'),
                backgroundColor: Colors.lightBlue,
                titleTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 24)),
            body: SafeArea(
                child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).padding.top +
                                kToolbarHeight),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      child: const Text('Image View',
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center)),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ImageScreen()))),
                              ElevatedButton(
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      child: const Text('Video View',
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center)),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const VideoScreen()))),
                              ElevatedButton(
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      child: const Text('Audio View',
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center)),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AudioScreen()))),
                              ElevatedButton(
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      child: const Text('Listing',
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center)),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Listing())))
                            ]))))));
  }
}
