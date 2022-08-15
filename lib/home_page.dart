import 'package:flutter/material.dart';
import 'package:streaming_app/resources.dart';
import 'package:streaming_app/video_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Streaming APP"),
      ),
      body: ListView.builder(
        itemCount: Resources().videoUrls.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: VideoListTile(
              videoUrl: Resources().videoUrls[index], index: index),
        ),
      ),
    );
  }
}
