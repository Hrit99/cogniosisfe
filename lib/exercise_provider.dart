import 'package:cogniosis/listing_widget.dart';
import 'package:flutter/material.dart';

class Exercise {
  final Duration duration;
  final String url;

  Exercise({
    required this.duration,
    required this.url,
  });
}

class ExerciseContent {
  final String title;
  final String author;
  final String image;
  final List<Exercise> exercises;
  final String description;
   bool isFavourite;

  ExerciseContent({
    required this.title,
    required this.author,
    required this.image,
    required this.exercises,
    required this.isFavourite,
    required this.description,
  });
}

//  Music(
//       title: 'The Calming Breath',
//       author: 'John Doe',
//       image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med+-+the+calming+breath.png',
//       isFavourite: false,
//       melodies: [
//         Melody(duration: Duration(minutes: 20, seconds: 53), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/01+The+Calming+Breath.mp3'),
//       ],
//       description: 'This is a meditation session',

//     ),
//       Music(
//       title: 'Calm Descending',
//       author: 'John Doe',
//       image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med-+Calm+descending.png',
//       isFavourite: false,
//       melodies: [
//         Melody(duration: Duration(minutes: 25, seconds: 53), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/02+Calm+Descending.mp3'),
//       ],
//       description: 'This is a meditation session',
//     ),
//       Music(
//       title: 'Endless Calm',
//       author: 'John Doe',
//       image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med+-+Endless+Calm.png',
//       isFavourite: false,
//       melodies: [
//         Melody(duration: Duration(minutes: 26, seconds: 32), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/03+Endless+Calm.mp3'),
//       ],
//       description: 'This is a meditation session',
//     ),
    //    Music(
    //   title: 'Adrift' ,
    //   author: 'John Doe',
    //   image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Relax+Adrift+7min.png',
    //   isFavourite: false,
    //   melodies: [
    //     Melody(duration: Duration(hours: 1, seconds: 50), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Adrift.mp3'),
    //   ],
    //   description: 'This is a meditation session',
    // ),
//        Music(
//       title: 'Daydreams',
//       author: 'John Doe',
//       image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Music-+Daydreams.png',
//       isFavourite: false,
//       melodies: [
//         Melody(duration: Duration(minutes: 33), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Daydreams.mp3'),
//       ],
//       description: 'This is a meditation session',
//     ),
//     Music(
//       title: 'Deep Inner Stillness',
//       author: 'John Doe',
//       image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med-+Deep+inner+stillness.png',
//       isFavourite: false,
//       melodies: [
//         Melody(duration: Duration(minutes: 35), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Deep-Inner-Stillness.mp3'),
//       ],
//       description: 'This is a meditation session',
//     ),
    // Music(
    //   title: 'Etherea Magic Dream Edition',
    //   author: 'John Doe',
    //   image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Sleep+Etherea+magic+dream+edition.png',
    //   isFavourite: false,
    //   melodies: [
    //     Melody(duration: Duration(hours: 1), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Etherea+-+Magic+Dream+Edition+-+Delta.mp3'),
    //   ],
    //   description: 'This is a meditation session',
    // ),
// Music(
//   title: 'Ethereal Awakening',
//   author: 'John Doe',
//   image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Relax+Ethereal+Awakening.png',
//   isFavourite: false,
//   melodies: [
//     Melody(duration: Duration(minutes: 4, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Ethereal-Awakening.mp3'),
//   ],
//   description: 'This is a meditation session',
// ),
//     Music(
//       title: 'Into The Deep',
//       author: 'John Doe',
//       image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Sleep+-+into+the+deep.png',
//       isFavourite: false,
//       melodies: [
//         Melody(duration: Duration(hours: 1, seconds: 3), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Deep+-+Delta.mp3'),
//         Melody(duration: Duration(hours: 1, seconds: 3), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Deep+-+Quiet+Seas+Edition+-+Delta.mp3'),
//       ],
//       description: 'This is a meditation session',
//     ),
    // Music(
    //   title: 'Letting Go',
    //   author: 'John Doe',
    //   image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+relax+-+Letting+go.png',
    //   isFavourite: false,
    //   melodies: [
    //     Melody(duration: Duration(hours: 1, minutes: 2, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Letting+Go+(Delta).mp3'),
    //   ],
    //   description: 'This is a meditation session',
    // ),
    // Music(
    //   title: 'Into The Light',
    //   author: 'John Doe',
    //   image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Relax+-+into+the+light.png',
    //   isFavourite: false,
    //   melodies: [
        // Melody(duration: Duration(hours: 1), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Light+-+Delta.mp3'),
        // Melody(duration: Duration(hours: 1), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Light+-+Quiet+Seas+Edition+-+Delta.mp3'),
    //   ],
    //   description: 'This is a meditation session',
    // ),
//     Music(
//       title: 'Mystic Dawn',
//       author: 'John Doe',
//       image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+relax+-+mystic+dawn.png',
//       isFavourite: false,
//       melodies: [
//         Melody(duration: Duration(hours: 1, minutes: 1, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Mystic+Dawn.mp3'),
//       ],
//       description: 'This is a meditation session',
//     ),
//     Music(
//       title: 'Progressive Muscle Relaxation',
//       author: 'John Doe',
//       image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Med-+Progressive+Muscle+relaxation.png',
//       isFavourite: false,
//       melodies: [
//         Melody(duration: Duration(minutes: 22), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Progressive-Muscle-Relaxation.mp3'),
//       ],
//       description: 'This is a meditation session',
//     ),

class ExerciseProvider with ChangeNotifier {
  final List<ExerciseContent> _exercises = [
   ExerciseContent(
     title: 'Adrift',
     author: 'Christopher Lloyd-Clarke',
     image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Relax+Adrift+7min.png',
     isFavourite: false,
     description: 'This is a meditation session',
     exercises: [
      Exercise(duration: Duration(hours: 1, seconds: 50), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Adrift.mp3'),
     ],
    ),
    ExerciseContent(
      title: 'Etherea Magic Dream Edition',
      author: 'Christopher Lloyd-Clarke',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Sleep+Etherea+magic+dream+edition.png',
      isFavourite: false,
      exercises: [
        Exercise(duration: Duration(hours: 1), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Etherea+-+Magic+Dream+Edition+-+Delta.mp3'),
      ],
      description: 'This is a meditation session',
    ),
    ExerciseContent(
      title: 'Into the Deep',
      author: 'Christopher Lloyd-Clarke',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Sleep+-+into+the+deep.png',
      isFavourite: false,
      exercises: [
        Exercise(duration: Duration(hours: 1, seconds: 3), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Deep+-+Delta.mp3'),
        Exercise(duration: Duration(hours: 1, seconds: 3), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Deep+-+Quiet+Seas+Edition+-+Delta.mp3'),
      ],
      description: 'This is a meditation session',
    ),
  ];

  void toggleFavourite(ExerciseContent exerciseContent) {
    exerciseContent.isFavourite = !exerciseContent.isFavourite;
    notifyListeners();
  }

  List<MediaItem> getExercises() {
    return _exercises.map((exerciseContent) => MediaItem(
      description: exerciseContent.description,
      image: exerciseContent.image,
      title: exerciseContent.title,
      duration: '${exerciseContent.exercises.first.duration.inHours}h ${exerciseContent.exercises.first.duration.inMinutes.remainder(60)}m',
      author: exerciseContent.author,
      isFavourite: exerciseContent.isFavourite,
      mediaUrls: exerciseContent.exercises.map((exercise) => exercise.url).toList(),
      onFavouritePressed: (mediaItem) {
        toggleFavourite(exerciseContent);
      },
    )).toList();
  }
}
