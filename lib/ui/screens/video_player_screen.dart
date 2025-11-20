import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({required this.videoUrl, Key? key}): super(key:key);

  @override
  State createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerScreen> {
  late VideoPlayerController _vController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _vController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(videoPlayerController: _vController, autoPlay: true);
        });
      });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _vController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) return Center(child: CircularProgressIndicator());
    return Scaffold(body: Chewie(controller: _chewieController!));
  }
}
