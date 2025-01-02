import 'package:flutter/material.dart';
import 'package:cogniosis/models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = []; // List of habits

  List<Habit> get habits => _habits;

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void removeHabit(String habitName, String habitTime) async {
    _habits.removeWhere((habit) => habit.name == habitName && habit.time == habitTime);
    
    // Clear stored completion data
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    keys.where((key) => key.startsWith('${habitName}_')).forEach((key) {
      prefs.remove(key);
    });
    
    notifyListeners();
  }

  Future<bool> getHabitCompletedOnDay(DateTime date, String habitName) async {
    final prefs = await SharedPreferences.getInstance();
    final String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final String key = "${habitName}_$formattedDate";
    print(key);
    return prefs.getBool(key) ?? false;
  }


  Future<double> getHabitsCompletedOnDay(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    int completedHabitsCount = 0;
    for (var habit in _habits) {
      final String key = "${habit.name}_$formattedDate";
      if (prefs.getBool(key) ?? false) {
        completedHabitsCount++;
      }
    }

    String getDayNameByDate(DateTime date) {
      switch (date.weekday) {
        case DateTime.monday:
          return 'Monday';
        case DateTime.tuesday:
          return 'Tuesday';
        case DateTime.wednesday:
          return 'Wednesday';
        case DateTime.thursday:
          return 'Thursday';
        case DateTime.friday:
          return 'Friday';
        case DateTime.saturday:
          return 'Saturday';
        case DateTime.sunday:
          return 'Sunday';
        default:
          return '';
      }
    }
    final int totalHabits = _habits.where((habit) => habit.days!.contains(getDayNameByDate(date))).length;
    if (totalHabits == 0) return 0.0;
    return (completedHabitsCount / totalHabits) * 100;
  }

  Future<void> setHabitCompletedOnDay(DateTime date, String habitName, bool isCompleted) async {
    final prefs = await SharedPreferences.getInstance();
    final String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final String key = "${habitName}_$formattedDate";
    print(key);
    print(isCompleted);
    await prefs.setBool(key, isCompleted);
    notifyListeners();
  }

   

  List<String?> getUniqueTimes() {
    return _habits.map((habit) => habit.time).toSet().toList();
  }

  Future<Map<String, Map<String, Object>>> getWeekData(DateTime now) async {
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    Map<String, Map<String, Object>> weekData = {
      'Mon': {"completed": 0, "date": "${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}"},
      'Tue': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 1)).year}-${startOfWeek.add(Duration(days: 1)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 1)).day.toString().padLeft(2, '0')}"},
      'Wed': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 2)).year}-${startOfWeek.add(Duration(days: 2)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 2)).day.toString().padLeft(2, '0')}"},
      'Thu': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 3)).year}-${startOfWeek.add(Duration(days: 3)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 3)).day.toString().padLeft(2, '0')}"},
      'Fri': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 4)).year}-${startOfWeek.add(Duration(days: 4)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 4)).day.toString().padLeft(2, '0')}"},
      'Sat': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 5)).year}-${startOfWeek.add(Duration(days: 5)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 5)).day.toString().padLeft(2, '0')}"},
      'Sun': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 6)).year}-${startOfWeek.add(Duration(days: 6)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 6)).day.toString().padLeft(2, '0')}"},
    };

    // Populate weekData with actual completion data
 
      for (var entry in weekData.entries) {
        DateTime date = DateTime.parse(entry.value['date'] as String);
        int completed = (await getHabitsCompletedOnDay(date)).ceil();
        entry.value['completed'] = completed;
      }

    return weekData;
  }

  Future<Map<String, Map<String, Object>>> getWeekDataForHabit(DateTime now, String habitName) async {
    print("getWeekDataForHabit");
    print(habitName);
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    Map<String, Map<String, Object>> weekData = {
      'Mon': {"completed": 0, "date": "${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}", "present": false},
      'Tue': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 1)).year}-${startOfWeek.add(Duration(days: 1)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 1)).day.toString().padLeft(2, '0')}", "present": false},
      'Wed': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 2)).year}-${startOfWeek.add(Duration(days: 2)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 2)).day.toString().padLeft(2, '0')}", "present": false},
      'Thu': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 3)).year}-${startOfWeek.add(Duration(days: 3)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 3)).day.toString().padLeft(2, '0')}", "present": false},
      'Fri': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 4)).year}-${startOfWeek.add(Duration(days: 4)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 4)).day.toString().padLeft(2, '0')}", "present": false},
      'Sat': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 5)).year}-${startOfWeek.add(Duration(days: 5)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 5)).day.toString().padLeft(2, '0')}", "present": false},
      'Sun': {"completed": 0, "date": "${startOfWeek.add(Duration(days: 6)).year}-${startOfWeek.add(Duration(days: 6)).month.toString().padLeft(2, '0')}-${startOfWeek.add(Duration(days: 6)).day.toString().padLeft(2, '0')}", "present": false},
    };

    // Populate weekData with actual completion data for the specific habit
    for (var entry in weekData.entries) {
      DateTime date = DateTime.parse(entry.value['date'] as String);
      bool isCompleted = await getHabitCompletedOnDay(date, habitName);
      entry.value['completed'] = isCompleted ? 100 : 0;
      print(entry.key);
      print(_getFullDayName(entry.key));
      _habits.where((habit) => habit.name == habitName).forEach((habit) {
        print(habit.days);
      });
      entry.value['present'] = _habits.any((habit) => habit.name == habitName && habit.days!.contains(_getFullDayName(entry.key)));
    }

    return weekData;
  }

  String _getFullDayName(String shortName) {
    switch (shortName) {
      case 'Mon':
        return 'Monday';
      case 'Tue':
        return 'Tuesday';
      case 'Wed':
        return 'Wednesday';
      case 'Thu':
        return 'Thursday';
      case 'Fri':
        return 'Friday';
      case 'Sat':
        return 'Saturday';
      case 'Sun':
        return 'Sunday';
      default:
        return shortName;
    }
  }
}
