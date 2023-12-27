import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const CustomVideoPlayer({required this.videoUrl});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool isPlay = false;
  late CachedVideoPlayerController videoController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlay) {
                  videoController.pause();
                } else {
                  videoController.play();
                }
                setState(() {
                  isPlay = !isPlay;
                });
              },
              icon: !isPlay
                  ? const Icon(
                      Icons.play_circle,
                      size: 30,
                    )
                  : const Icon(
                      Icons.pause_circle,
                      size: 30,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
