import 'package:cogniosis/listing_widget.dart';
import 'package:flutter/material.dart';

class Melody {
  final Duration duration;
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
      title: 'Zen Meditation',
      author: 'Roisin',
      image:
          'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/Zen.png',
      melodies: [
        Melody(
            duration: Duration(minutes: 10),
            url:
                'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/Roisin+Zen+01+(1).mp3'),
      ],
      isFavourite: false,
      description:
          'Encourages self-awareness and insight through seated meditation with focus on posture and breath.',
    ),

    Music(
        title: 'Transcendental Meditation',
        author: 'Roisin',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/transcendental.png',
        melodies: [
          Melody(
              duration: Duration(minutes: 10),
              url:
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/Roisin+Transdental+01+(1).mp3'),
        ],
        isFavourite: false,
        description:
            'Promotes deep relaxation and restful awareness through the repetition of a personalized mantra.'),

    Music(
        title: 'Movement Meditation ',
        author: 'Roisin',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/3.png',
        melodies: [
          Melody(
              duration: Duration(minutes: 10),
              url:
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/Roisin+Movement+01+(1).mp3'),
        ],
        isFavourite: false,
        description:
            'Integrates mindfulness with physical activity to connect the mind and body, improving body awareness.'),

    Music(
        title: 'Progressive Meditation',
        author: 'Roisin',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/4.png',
        melodies: [
          Melody(
              duration: Duration(minutes: 10),
              url:
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/Roisin+Progressive+relaxation+01+(3).mp3'),
        ],
        isFavourite: false,
        description:
            'Promotes physical and mental relaxation by systematically releasing tension throughout the body.'),

    Music(
        title: 'Sound Vibration Meditation',
        author: 'Roisin',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/5.png',
        melodies: [
          Melody(
              duration: Duration(minutes: 10),
              url:
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/Roisin+Sound+meditation+10+min.mp3'),
        ],
        isFavourite: false,
        description:
            'Harmonizes mind and body by using sounds, chants, or vibrations as a meditative focus.'),

    Music(
        title: 'Mindfulness Meditation',
        author: 'Roisin',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/6.png',
        melodies: [
          Melody(
              duration: Duration(minutes: 10),
              url:
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/Roisin+-+Mindfulness+01.mp3'),
        ],
        isFavourite: false,
        description:
            'Enhances awareness by observing thoughts, emotions, and sensations in the present moment without judgment.'),

    Music(
        title: 'Concentration Meditation',
        author: 'Roisin',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/7.png',
        melodies: [
          Melody(
              duration: Duration(minutes: 10),
              url:
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/Roisin+Concentration+01+(1).mp3'),
        ],
        isFavourite: false,
        description:
            'Cultivates focus and mental discipline by directing attention to a single point, such as breath, a mantra, or a flame.'),

    Music(
        title: 'Loving-kindness Meditation',
        author: 'Roisin',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/8.png',
        melodies: [
          Melody(
              duration: Duration(minutes: 10),
              url:
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/Roisin+Loving+Kindness+01+(1).mp3'),
        ],
        isFavourite: false,
        description:
            'Develops compassion and emotional healing by fostering unconditional love for oneself and others.'),

    Music(
        title: 'Endless Calm',
        author: 'Linda Hall',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/endlesscalm.png',
        melodies: [
          Melody(
              duration: Duration(minutes: 23),
              url:
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/03+Endless+Calm.mp3'),
        ],
        isFavourite: false,
        description: 'This is a meditative session.'),
    Music(
        title: 'Calm Descending',
        author: 'Linda Hall',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/3.png',
        melodies: [
          Melody(
              duration: Duration(minutes: 26),
              url:
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/02+Calm+Descending.mp3'),
        ],
        isFavourite: false,
        description: 'This is a relaxation session'),
    Music(
        title: 'Dolphin Reconnection',
        author: 'Brad Austen',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/dolphin.png',
        melodies: [
          Melody(duration: Duration(minutes: 14), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/03+Dolphin+Reconnection+Meditation.mp3'),
        ],
        isFavourite: false,
        description: 'This is a meditation session'),
    Music(
        title: 'The Calm Breath',
        author: 'Linda Hall',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/1.png',
        melodies: [
          Melody(duration: Duration(minutes: 21), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/01+The+Calming+Breath.mp3'),
        ],
        isFavourite: false,
        description: 'This is a meditation session'),
    Music(
        title: 'Relax At The Beach',
        author: 'Brad Austen',
        image:
            'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/beach.png',
        melodies: [
          Melody(duration: Duration(minutes: 14), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/01+Message+In+A+Bottle+Meditation.mp3'),
        ],
        isFavourite: false,
        description: 'This is a meditation session'),
    // Add more tasks as needed
  ];

  void toggleFavourite(Music music) {
    music.isFavourite = !music.isFavourite;
    notifyListeners();
  }

  List<MediaItem> getMusic() {
    return _music
        .map((music) => MediaItem(
              description: music.description,
              image: music.image,
              title: music.title,
              duration:
                  '${music.melodies.first.duration.inHours}h ${music.melodies.first.duration.inMinutes.remainder(60)}m',
              author: music.author,
              isFavourite: music.isFavourite,
              mediaUrls: music.melodies.map((melody) => melody.url).toList(),
              onFavouritePressed: (mediaItem) {
                toggleFavourite(music);
              },
            ))
        .toList();
  }
}
