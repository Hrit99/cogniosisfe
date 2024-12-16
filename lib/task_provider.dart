import 'package:flutter/material.dart';

class Task {
  final String title;
  final String duration;
  final String date;
  final String image;
  bool isCompleted;

  Task({
    required this.title,
    required this.duration,
    required this.date,
    required this.image,
    this.isCompleted = false,
  });
}

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      title: 'Go For Jogging',
      duration: '10 mins',
      date: '09:00 - 12/09/2023',
      image: 'assets/nebula.jpeg',
      isCompleted: true,
    ),
      Task(
      title: 'Go For Jogging',
      duration: '10 mins',
      date: '09:00 - 12/09/2023',
      image: 'assets/nebula.jpeg',
      isCompleted: true,
    ),
      Task(
      title: 'Go For Jogging',
      duration: '10 mins',
      date: '09:00 - 12/09/2023',
      image: 'assets/nebula.jpeg',
      isCompleted: false,
    )
    // Add more tasks as needed
  ];

  List<Task> getTasksByCategory(String category) {
    if (category == 'All') {
      return _tasks;
    }
    else if(category == 'Pending'){
      return _tasks.where((task) => !task.isCompleted).toList();
    }
    else if(category == 'Resolved'){
      return _tasks.where((task) => task.isCompleted).toList();
    }
    return [];
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }
}