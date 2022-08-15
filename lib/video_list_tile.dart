import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListTile extends StatefulWidget {
  final String videoUrl;
  final int index;
  const VideoListTile({required this.videoUrl, Key? key, required this.index})
      : super(key: key);

  @override
  State<VideoListTile> createState() => _VideoListTileState();
}

class _VideoListTileState extends State<VideoListTile> {
  YoutubePlayerController controller =
      YoutubePlayerController(initialVideoId: '');
  Duration? _position;
  int? likeCount;
  int? unLikeCount;

  @override
  initState() {
    _setInit();
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: false,
        enableCaption: false,
      ),
    )..addListener(() {
        Timer.run(() {
          setState(() {
            _position = controller.value.position;
          });
        });
      });
    super.initState();
  }

  @override
  void deactivate() {
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _setInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    likeCount = (prefs.getInt('likeCounter${widget.index}') ?? 0);
    unLikeCount = (prefs.getInt('unlikeCounter${widget.index}') ?? 0);
  }

  _incrementLikeCounter() async {
    print("++++++++++like+++++++++++");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    likeCount = (prefs.getInt('likeCounter${widget.index}') ?? 0) + 1;
    print('Pressed $likeCount times.');
    await prefs.setInt('likeCounter${widget.index}', likeCount!);
  }

  _incrementUnLikeCounter() async {
    print("++++++++++unlike+++++++++++");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    unLikeCount = (prefs.getInt('unlikeCounter${widget.index}') ?? 0) + 1;
    print('Pressed $unLikeCount times.');
    await prefs.setInt('unlikeCounter${widget.index}', unLikeCount!);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.videoUrl);
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          progressColors: const ProgressBarColors(playedColor: Colors.red),
        ),
        builder: (context, player) {
          if (_position?.inSeconds == 5) {
            controller.pause();
            Future.delayed(Duration.zero, () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    print("showDialog");
                    return AlertDialog(
                      title: const Text("Do you like this video?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              _incrementLikeCounter();
                              Navigator.pop(context);
                              Navigator.pop(context);
                              controller.seekTo(const Duration(seconds: 6),
                                  allowSeekAhead: true);
                              controller.play();
                            },
                            child: const Text("Yes")),
                        TextButton(
                            onPressed: () {
                              _incrementUnLikeCounter();
                              Navigator.pop(context);
                              Navigator.pop(context);
                              controller.seekTo(const Duration(seconds: 6),
                                  allowSeekAhead: true);
                              controller.play();
                            },
                            child: const Text("No")),
                      ],
                    );
                  });
            });
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              player,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thumb_up),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${likeCount ?? 0}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.thumb_down),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${unLikeCount ?? 0}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        });
  }
}
