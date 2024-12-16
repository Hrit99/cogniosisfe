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

  ExerciseContent({
    required this.title,
    required this.author,
    required this.image,
    required this.exercises,
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
    ),
    ExerciseContent(
      title: 'Cardio Blast',
      author: 'Bob Johnson',
      image: 'assets/nebula.jpeg',
      exercises: [
        Exercise(duration: Duration(minutes: 20), url: 'https://example.com/exercise3.mp4'),
        Exercise(duration: Duration(minutes: 35), url: 'https://example.com/exercise4.mp4'),
      ],
    ),
    ExerciseContent(
      title: 'Strength Training',
      author: 'Carol Williams',
      image: 'assets/nebula.jpeg',
      exercises: [
        Exercise(duration: Duration(minutes: 40), url: 'https://example.com/exercise5.mp4'),
        Exercise(duration: Duration(minutes: 50), url: 'https://example.com/exercise6.mp4'),
      ],
    ),
    // Add more exercise content as needed
  ];

  List<MediaItem> getExercises() {
    return _exercises.map((exerciseContent) => MediaItem(
      image: exerciseContent.image,
      title: exerciseContent.title,
      duration: exerciseContent.exercises.first.duration.toString(),
      author: exerciseContent.author,
    )).toList();
  }
}
