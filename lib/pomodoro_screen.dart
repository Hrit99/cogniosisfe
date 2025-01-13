import 'package:cogniosis/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PomodoroScreen extends StatelessWidget {
  final bool isDarkMode;
  final String title;

  const PomodoroScreen({Key? key, required this.isDarkMode, required this.title}) : super(key: key);

  Map<String, Map<String, Object>> _transformTasksToWeekData(List<Task> tasks) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    Map<String, Map<String, Object>> weekData = {
      'Mon': {
        "completed": 0,
        "date": startOfWeek.toString(),
      },
      'Tue': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 1)).toString(),
      },
      'Wed': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 2)).toString(),
      },
      'Thur': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 3)).toString(),
      },
      'Fri': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 4)).toString(),
      },
      'Sat': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 5)).toString(),
      },
      'Sun': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 6)).toString(),
      },
    };

    for (var task in tasks) {
      final day = task.date.weekday;
      switch (day) {
        case DateTime.monday:
          weekData['Mon']!['completed'] = (weekData['Mon']!['completed'] as int) +
              ((task.durationCompleted.inSeconds * 100) ~/ task.duration.inSeconds);
          break;
        case DateTime.tuesday:
          weekData['Tue']!['completed'] = (weekData['Tue']!['completed'] as int) +
              ((task.durationCompleted.inSeconds * 100) ~/ task.duration.inSeconds);
          break;
        case DateTime.wednesday:
          weekData['Wed']!['completed'] = (weekData['Wed']!['completed'] as int) +
              ((task.durationCompleted.inSeconds * 100) ~/ task.duration.inSeconds);
          break;
        case DateTime.thursday:
          weekData['Thur']!['completed'] = (weekData['Thur']!['completed'] as int) +
              ((task.durationCompleted.inSeconds * 100) ~/ task.duration.inSeconds);
          break;
        case DateTime.friday:
          weekData['Fri']!['completed'] = (weekData['Fri']!['completed'] as int) +
              ((task.durationCompleted.inSeconds * 100) ~/ task.duration.inSeconds);
          break;
        case DateTime.saturday:
          weekData['Sat']!['completed'] = (weekData['Sat']!['completed'] as int) +
              ((task.durationCompleted.inSeconds * 100) ~/ task.duration.inSeconds);
          break;
        case DateTime.sunday:
          weekData['Sun']!['completed'] = (weekData['Sun']!['completed'] as int) +
              ((task.durationCompleted.inSeconds * 100) ~/ task.duration.inSeconds);
          break;
        default:
          break;
      }
    }

    for (var entry in weekData.entries) {
      try {
        final taskDate = DateTime.parse(entry.value['date'] as String);
        int taskCount = tasks.where((task) => task.date.weekday == taskDate.weekday).length;
        entry.value['completed'] = ((entry.value['completed'] as int) ~/ (taskCount > 0 ? taskCount : 1));
      } catch (e) {
        entry.value['completed'] = 0; // or some default value
      }
    }
    return weekData;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    List<Task> tasks = taskProvider.getWeekData();

    String errorMessage = '';
    Map<String, Map<String, Object>> weekData = {};

    try {
      weekData = _transformTasksToWeekData(tasks);
    } catch (e) {
      errorMessage = 'Error: ${e.toString()}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: errorMessage.isNotEmpty
            ? Text(errorMessage, style: TextStyle(color: Colors.red))
            : Text('This is a simple screen'),
      ),
    );
  }
}
