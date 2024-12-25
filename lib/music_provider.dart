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
  final String description;
   bool isFavourite; 
  

  Music({
    required this.title,
    required this.author,
    required this.image,
    required this.melodies,
    required this.isFavourite,
    required this.description,
    });
}

class MusicProvider with ChangeNotifier {
  final List<Music> _music = [
    Music(
      title: 'Go For Jogging',
      author: 'John Doe',
      image: 'assets/nebula.jpeg',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 10), url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
        Melody(duration: Duration(minutes: 15), url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
      ],
      description: 'This is a meditation session',


    ),
      Music(
      title: 'Go For Jogging',
      author: 'John Doe',
      image: 'assets/nebula.jpeg',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 10), url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
        Melody(duration: Duration(minutes: 15), url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
      ],
      description: 'This is a meditation session',
    ),
      Music(
      title: 'Go For Jogging',
      author: 'John Doe',
      image: 'assets/nebula.jpeg',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 10), url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
        Melody(duration: Duration(minutes: 15), url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
      ],
      description: 'This is a meditation session',
    )
    // Add more tasks as needed
  ];

  void toggleFavourite(Music music) {
    music.isFavourite = !music.isFavourite;
    notifyListeners();
  }

  List<MediaItem> getMusic() {
    return _music.map((music) => MediaItem(
      description: music.description,
      image: music.image,
      title: music.title,
      duration: '${music.melodies.first.duration.inHours}h ${music.melodies.first.duration.inMinutes.remainder(60)}m',
      author: music.author,
      isFavourite: music.isFavourite,
      mediaUrls: music.melodies.map((melody) => melody.url).toList(),
      onFavouritePressed: (mediaItem) {
        toggleFavourite(music);
      },
    )).toList();
  }

}