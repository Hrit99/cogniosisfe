import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodProvider with ChangeNotifier {
  Map<String, String> _moodData = {};

  Map<String, String> get moodData => _moodData;

  Future<void> loadMoodData() async {

      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys(); 

      _moodData = {for (var key in keys) if (key.startsWith('mood_')) key.replaceFirst('mood_', ''): prefs.getString(key) ?? ''};
      notifyListeners();

  }

  Future<void> setMood(String date, String mood) async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mood_${date}', mood);
    _moodData[date] = mood;
    notifyListeners();
  }

  String getMood(String date) {
    return _moodData[date] ?? 'No mood set';
  }

  Future<void> clearMoodData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _moodData.clear();
    notifyListeners();
  }

  Map<String, String> getMonthMood(DateTime startOfMonth) {
    final Map<String, String> monthMood = {};
    final int daysInMonth = DateTime(startOfMonth.year, startOfMonth.month + 1, 0).day;
    for (int i = 0; i < daysInMonth; i++) {
      final date = startOfMonth.add(Duration(days: i)).toIso8601String().split('T').first;
      if (_moodData.containsKey(date)) {
        monthMood[date] = _moodData[date]!;
      } else {
        monthMood[date] = 'No mood set';
      }
    }
    return monthMood;
  }
} 