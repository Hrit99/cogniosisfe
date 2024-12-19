import 'package:flutter/material.dart';

class Task {
  final int id;
  final String title;
  final Duration duration;
  final DateTime date;
  final String image;
  Duration durationCompleted;
  String note;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.duration,
    required this.date,
    required this.image,

    this.isCompleted = false,
    this.durationCompleted = Duration.zero,
    this.note = "",
  });
}


class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

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

  List<Task> getWeekData(){
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    
    return _tasks.where((task) => task.date.isAfter(startOfWeek) && task.date.isBefore(endOfWeek)).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
    print(task.title);
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void setTasks(List<Task> tasks) {
    _tasks.clear();
    _tasks.addAll(tasks);
    notifyListeners();
  }
}