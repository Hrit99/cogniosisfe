import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> loadTasks() async {
    if (_tasks.isNotEmpty) {
      return;
    }

    final url = Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/tasks');
    String accessToken = "";
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> taskList = jsonDecode(response.body);
      final List<Task> loadedTasks = taskList.map((taskData) {
        print('taskData: ' + taskData['date']);
        print('taskData type: ' + taskData['date'].runtimeType.toString());
        return Task(
          id: taskData['id'],
          title: taskData['title'],
          duration: Duration(
            hours: int.parse(taskData['duration'].split(':')[0]),
            minutes: int.parse(taskData['duration'].split(':')[1]),
            seconds: int.parse(taskData['duration'].split(':')[2]),
          ),
          date: DateTime.parse(taskData['date'].split('T')[0]),
          image: taskData['image'],
          isCompleted: taskData['is_completed'],
          durationCompleted: Duration(
            hours: int.parse(taskData['duration_completed'].split(':')[0]),
            minutes: int.parse(taskData['duration_completed'].split(':')[1]),
            seconds: int.parse(taskData['duration_completed'].split(':')[2]),
          ),
          note: taskData['note'],
        );
      }).toList();
      print(loadedTasks);
      setTasks(loadedTasks);
      return;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

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
    DateTime startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = DateTime(now.year, now.month, now.day).add(Duration(days: DateTime.daysPerWeek - now.weekday));
    print("llll");
    print(_tasks.length);
    print(startOfWeek);
    return _tasks.where((task) => (task.date.isAfter(startOfWeek) || task.date.isAtSameMomentAs(startOfWeek)) && (task.date.isBefore(endOfWeek) || task.date.isAtSameMomentAs(endOfWeek))).toList();
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
    // notifyListeners();
  }
}