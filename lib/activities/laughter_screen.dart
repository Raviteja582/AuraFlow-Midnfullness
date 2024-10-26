import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class LaughterScreen extends StatelessWidget {
  const LaughterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text(
            "Laughter Videos",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Playwrite'),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/background.png'), // Specify the image path
                  fit: BoxFit.cover, // Cover the entire screen
                ),
              ),
            ),
            Center(
              child: ListView(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Laughter can make you healthy!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Playwrite'),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  VideoPlayerWidget(videoAsset: 'assets/myvideo_1.mp4'),
                  const SizedBox(height: 10.0),
                  VideoPlayerWidget(videoAsset: 'assets/myvideo_2.mp4'),
                  const SizedBox(height: 10.0),
                  VideoPlayerWidget(videoAsset: 'assets/myvideo_3.mp4'),
                  const SizedBox(height: 10.0),
                ],
              ),
            )
          ],
        ));
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoAsset;

  VideoPlayerWidget({super.key, required this.videoAsset});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _isVideoInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _controller = VideoPlayerController.asset(widget.videoAsset);
    await _controller.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9, // Adjust this to match your video's aspect ratio
      autoInitialize: true,
      autoPlay: false,
      looping: false,
    );

    if (mounted) {
      setState(() {
        _isVideoInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: Column(
        children: <Widget>[
          Container(
            width: 300.0, // Set a fixed width
            height: 200.0, // Set a fixed height
            child: _isVideoInitializing
                ? (Container(
                    width: 40.0, // Set a fixed width
                    height: 40.0, // Set a fixed height
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black), // Set the color
                        strokeWidth: 3.0, // Set the stroke width
                      ),
                    ),
                  )) // Set the stroke width) // Display a loading indicator
                : Chewie(controller: _chewieController),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }
}
