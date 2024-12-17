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

class ExerciseProvider with ChangeNotifier {
  final List<ExerciseContent> _exercises = [
    ExerciseContent(
      title: 'Morning Yoga',
      author: 'Alice Smith',
      image: 'assets/nebula.jpeg',
      exercises: [
        Exercise(duration: Duration(minutes: 30), url: 'https://example.com/exercise1.mp4'),
        Exercise(duration: Duration(minutes: 45), url: 'https://example.com/exercise2.mp4'),
      ],
      isFavourite: false,
      description: 'This is a yoga session',
    ),
    ExerciseContent(
      title: 'Cardio Blast',
      author: 'Bob Johnson',
      image: 'assets/nebula.jpeg',
      exercises: [
        Exercise(duration: Duration(minutes: 20), url: 'https://example.com/exercise3.mp4'),
        Exercise(duration: Duration(minutes: 35), url: 'https://example.com/exercise4.mp4'),
        ],
      isFavourite: false,
      description: 'This is a cardio session',
    ),
    ExerciseContent(
      title: 'Strength Training',
      author: 'Carol Williams',
      image: 'assets/nebula.jpeg',
      exercises: [
        Exercise(duration: Duration(minutes: 40), url: 'https://example.com/exercise5.mp4'),
        Exercise(duration: Duration(minutes: 50), url: 'https://example.com/exercise6.mp4'),
      ],
      isFavourite: false,
      description: 'This is a strength training session',
      ),
    // Add more exercise content as needed
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
