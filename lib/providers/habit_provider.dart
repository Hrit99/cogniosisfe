import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cogniosis/models/habit.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [
    Habit(name: 'Exercise', isActive: true, time: 'Anytime'),
    Habit(name: 'Meditate', isActive: true, time: 'Anytime'),
    Habit(name: 'Read', isActive: true, time: 'Morning'),
    Habit(name: 'Drink Water', isActive: true, time: 'Morning'),
  ];
  Map<String, bool> _habitCompletion = {};

  List<Habit> get habits => _habits;

  Future<void> toggleHabit(String name) async {
    final habit = _habits.firstWhere((habit) => habit.name == name);
    habit.isActive = !habit.isActive;
    notifyListeners();
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
}