import 'package:cogniosis/chat_screen.dart';
import 'package:cogniosis/checkin_screen.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/main.dart';
import 'package:cogniosis/meditation_screen.dart';
import 'package:flutter/material.dart';
import 'package:cogniosis/pomodoro_screen.dart';
import 'package:provider/provider.dart';
import 'package:cogniosis/home_screen.dart'; // Import the ThemeProvider
import 'package:cogniosis/screens/habit_screen.dart';

class ExpandableButtonRow extends StatefulWidget {
  @override
  _ExpandableButtonRowState createState() => _ExpandableButtonRowState();
}

class _ExpandableButtonRowState extends State<ExpandableButtonRow> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildButton(Icons.headset, 'Ai Talk', isDarkMode),
            SizedBox(width: getWidth(context, 9)), // Gap between tiles
            _buildButton(Icons.chat_bubble_outline, 'Ai Chat', isDarkMode),
            SizedBox(width: getWidth(context, 9)), // Gap between tiles
            _buildButton(Icons.self_improvement, 'Meditation', isDarkMode),
            SizedBox(width: getWidth(context, 9)), // Gap between tiles
            _buildButton(Icons.more_horiz, _isExpanded ? 'Less' : 'More',
                isDarkMode, _toggleExpand),
          ],
        ),
        SizedBox(height: getHeight(context, 10)), // Gap between tiles
        Visibility(
          visible: _isExpanded,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildButton(Icons.check_circle_outline, 'Check-in', isDarkMode),
              SizedBox(width: getWidth(context, 9)), // Gap between tiles
              _buildButton(Icons.timer, 'Pomodoro', isDarkMode),
              SizedBox(width: getWidth(context, 9)), // Gap between tiles
              _buildButton(Icons.calendar_today, 'Habit Tracker', isDarkMode),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(IconData icon, String label, bool isDarkMode,
      [VoidCallback? onPressed]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: onPressed ??
              () {
                if (label == 'Ai Chat') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(isDarkMode: isDarkMode)));
                }
                if (label == 'Ai Talk') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                              title: 'Ai Talk', isDarkMode: isDarkMode)));
                }
                if (label == 'Meditation') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MeditationScreen(
                              isDarkMode: isDarkMode, title: 'Meditation')));

                }
                if (label == 'Check-in') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckInScreen(
                              isDarkMode: isDarkMode, title: 'Check-in')));
                }
                if (label == 'Pomodoro') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PomodoroScreen(
                              isDarkMode: isDarkMode, title: 'Pomodoro')));
                }
                if (label == 'Habit Tracker') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HabitScreen(
                              isDarkMode: isDarkMode, title: 'Habit Tracker')));
                }
              },
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(context, 8),
                vertical: getHeight(context, 16)),
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
            foregroundColor: isDarkMode ? Colors.white : Colors.black,
            shadowColor: Colors.transparent,
          ),
          child: Column(
            children: [
              Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
              SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: getHeight(context, 12),
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
