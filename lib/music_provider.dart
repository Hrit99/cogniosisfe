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
      title: 'The Calming Breath',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med+-+the+calming+breath.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 20, seconds: 53), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/01+The+Calming+Breath.mp3'),
      ],
      description: 'This is a meditation session',


    ),
      Music(
      title: 'Calm Descending',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med-+Calm+descending.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 25, seconds: 53), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/02+Calm+Descending.mp3'),
      ],
      description: 'This is a meditation session',
    ),
      Music(
      title: 'Endless Calm',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med+-+Endless+Calm.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 26, seconds: 32), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/03+Endless+Calm.mp3'),
      ],
      description: 'This is a meditation session',
    ),
       Music(
      title: 'Adrift' ,
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Relax+Adrift+7min.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(hours: 1, seconds: 50), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Adrift.mp3'),
      ],
      description: 'This is a meditation session',
    ),
       Music(
      title: 'Daydreams',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Music-+Daydreams.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 33), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Daydreams.mp3'),
      ],
      description: 'This is a meditation session',
    ),
    Music(
      title: 'Deep Inner Stillness',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med-+Deep+inner+stillness.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 35), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Deep-Inner-Stillness.mp3'),
      ],
      description: 'This is a meditation session',
    ),
    Music(
      title: 'Etherea Magic Dream Edition',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Sleep+Etherea+magic+dream+edition.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(hours: 1), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Etherea+-+Magic+Dream+Edition+-+Delta.mp3'),
      ],
      description: 'This is a meditation session',
    ),
    Music(
      title: 'Ethereal Awakening',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Relax+Ethereal+Awakening.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 4, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Ethereal-Awakening.mp3'),
      ],
      description: 'This is a meditation session',
    ),
    Music(
      title: 'Into The Deep', 
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Sleep+-+into+the+deep.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(hours: 1, seconds: 3), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Deep+-+Delta.mp3'),
        Melody(duration: Duration(hours: 1, seconds: 3), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Deep+-+Quiet+Seas+Edition+-+Delta.mp3'),
      ],
      description: 'This is a meditation session',
    ),
    Music(
      title: 'Letting Go',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+relax+-+Letting+go.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(hours: 1, minutes: 2, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Letting+Go+(Delta).mp3'),
      ],
      description: 'This is a meditation session',
    ),
    Music(
      title: 'Into The Light',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Relax+-+into+the+light.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(hours: 1), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Light+-+Delta.mp3'),
        Melody(duration: Duration(hours: 1), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Light+-+Quiet+Seas+Edition+-+Delta.mp3'),
      ],
      description: 'This is a meditation session',
    ),
    Music(
      title: 'Mystic Dawn',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+relax+-+mystic+dawn.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(hours: 1, minutes: 1, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Mystic+Dawn.mp3'),
      ],
      description: 'This is a meditation session',
    ),
    Music(
      title: 'Progressive Muscle Relaxation',
      author: 'John Doe',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med-+Progressive+Muscle+relaxation.png',
      isFavourite: false,
      melodies: [
        Melody(duration: Duration(minutes: 22), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Progressive-Muscle-Relaxation.mp3'),
      ],
      description: 'This is a meditation session',
    ),
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