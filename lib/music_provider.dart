import 'package:cogniosis/listing_widget.dart';
import 'package:flutter/material.dart';

class Melody {
  final   Duration  duration;
  final String url;

  Melody({
    required this.duration,
    required this.url,
  });
}

class Music {
  final String title;
  final String author;
  final String image;
  final List<Melody> melodies;
  

  Music({
    required this.title,
    required this.author,
    required this.image,
    required this.melodies,
  });
}

class MusicProvider with ChangeNotifier {
  final List<Music> _music = [
    Music(
      title: 'Go For Jogging',
      author: 'John Doe',
      image: 'assets/nebula.jpeg',
      melodies: [
        Melody(duration: Duration(minutes: 10), url: 'https://example.com/melody1.mp3'),
        Melody(duration: Duration(minutes: 15), url: 'https://example.com/melody2.mp3'),
      ],

    ),
      Music(
      title: 'Go For Jogging',
      author: 'John Doe',
      image: 'assets/nebula.jpeg',
      melodies: [
        Melody(duration: Duration(minutes: 10), url: 'https://example.com/melody1.mp3'),
        Melody(duration: Duration(minutes: 15), url: 'https://example.com/melody2.mp3'),
      ],
    ),
      Music(
      title: 'Go For Jogging',
      author: 'John Doe',
      image: 'assets/nebula.jpeg',
      melodies: [
        Melody(duration: Duration(minutes: 10), url: 'https://example.com/melody1.mp3'),
        Melody(duration: Duration(minutes: 15), url: 'https://example.com/melody2.mp3'),
      ],
    )
    // Add more tasks as needed
  ];

  List<MediaItem> getMusic() {
    return _music.map((music) => MediaItem(
      image: music.image,
      title: music.title,
      duration: music.melodies.first.duration.toString(),
      author: music.author,
    )).toList();
  }

}