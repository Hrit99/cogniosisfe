import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cogniosis/models/habit.dart';

class HabitProvider with ChangeNotifier {
 final List<Habit> _habits = [];
  Map<String, bool> _habitCompletion = {};
  


  List<Habit> get habits => _habits;

  Future<void> toggleHabit(String name, String day) async {
    print("toggleHabit");
    print(name);
    print(day);
    for (var habit in _habits) {
      if (habit.name == name) {
        print(habit.days);
      }
    }
    Habit? habit;
    for (var h in _habits) {
      if (h.name == name) {
        habit = h;
        break;
      }
    }
    if (habit == null) {
      return;
    }
    habit.isActive = !habit.isActive;
    print(habit.isActive);
    notifyListeners();
  }

  List<String?> getUniqueTimes() {
    return _habits.map((habit) => habit.time).toSet().toList();
  }


  Future<void> setHabitCompletion(String date, String habitName, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$date-$habitName';
    await prefs.setBool(key, completed);
    print(key);
    _habitCompletion[key] = completed;
    notifyListeners();
  }

  bool getHabitCompletion(String date, String habitName) {
    final key = '$date-$habitName';
    return _habitCompletion[key] ?? false;
  }

  Future<void> loadHabitCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    _habitCompletion = {for (var key in keys) key: prefs.getBool(key) ?? false};
    notifyListeners();
  }

  void addHabit(Habit habit) {
    print(habit.name);
    _habits.add(habit);
    for (var h in _habits) {
      print(h.name);
    }
    notifyListeners();
  }
}