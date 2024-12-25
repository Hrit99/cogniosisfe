import 'dart:math';
import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicWaveWithAudio extends StatefulWidget {
  final String audioUrl;

  MusicWaveWithAudio({required this.audioUrl, Key? key}) : super(key: key);

  @override
  MusicWaveWithAudioState createState() => MusicWaveWithAudioState();
}

extension MusicWaveWithAudioStateExtension on GlobalKey<MusicWaveWithAudioState> {
  void stopAudio() {
    currentState?.stopAudio();
  }

  void changeAudioUrl(String newUrl) {
    currentState?.changeAudioUrl(newUrl);
  }

  void playAudio(String url) {
    currentState?.playAudio(url);
  }

  void pauseAudio() {
    currentState?.pauseAudio();
  }

  void resumeAudio() {
    currentState?.resumeAudio();
  }
}

class MusicWaveWithAudioState extends State<MusicWaveWithAudio>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    playAudio(widget.audioUrl);
  }

  void playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      isPlaying = true;
    });
  }

  void stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void resumeAudio() async {
    await _audioPlayer.resume();
    setState(() {
      isPlaying = true;
    });
  }

  void changeAudioUrl(String newUrl) {
    stopAudio();
    playAudio(newUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _totalDuration.inMilliseconds > 0
        ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
        : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: getHeight(context, 100),
          width: getWidth(context, 362),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(34, (index) {
              return AnimatedBar(
                animation: _controller,
                delay: index * 50,
                progress: progress,
                index: index,
                totalBars: 34,
              );
            }),
          ),
        ),
      ],
    );
  }
}

class AnimatedBar extends StatelessWidget {
  final Animation<double> animation;
  final int delay;
  final double progress;
  final int index;
  final int totalBars;

  AnimatedBar({
    required this.animation,
    required this.delay,
    required this.progress,
    required this.index,
    required this.totalBars,
  });

  @override
  Widget build(BuildContext context) {
    double barProgress = (index + 1) / totalBars;
    Color barColor = Color.lerp(Color(0xFFF2F2F2).withOpacity(0.3), Colors.white, progress / barProgress)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(context, 2)),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: getHeight(context, 5), end: getHeight(context, 30)), // Decreased the height range
        duration: Duration(milliseconds: 400 + delay),
        builder: (context, value, child) {
          return Container(
            width: getWidth(context, 6),
            height: value + Random().nextInt(20), // Decreased the random height addition
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }
}