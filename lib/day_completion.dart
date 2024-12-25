import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekProgressWidget extends StatelessWidget {
  final Map<String, Map<String, Object>> weekData;
  final bool isTop;

  const WeekProgressWidget({Key? key, required this.weekData, this.isTop = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekData.entries.map((entry) {
        return _DayProgressCircle(
          isTop: isTop,
          day: entry.key,
          progress: entry.value['completed'] as int,
          date: entry.value['date'] as DateTime,
        );
      }).toList(),
    );
  }
}

class _DayProgressCircle extends StatelessWidget {
  final String day;
  final int progress;
  final DateTime date;
  final bool isTop;


  const _DayProgressCircle({Key? key, required this.day, required this.progress, required this.date, this.isTop = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Column(
      children: [
          isTop ? Text(
          day,
          style: TextStyle(
            fontFamily: 'Satoshi',
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ) : const SizedBox.shrink(),
           const SizedBox(height: 5),
        Container(
          height: getWidth(context, 40),
          width: getWidth(context, 40),
          decoration: BoxDecoration(
            color: isTop ? Colors.transparent : (date.isBefore(DateTime.now().subtract(Duration(days: 1))) && progress != 100 ? Colors.red : (progress == 100 ? Color(0xFF099AA8) : (isDarkMode ? Colors.transparent : Colors.white))),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Stack(
            children: [
              // Background Circle
              CircularProgressIndicator(
                value: 1, // full circle as background
                strokeWidth: getWidth(context, 2),
                valueColor: AlwaysStoppedAnimation<Color>(isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              // Progress Circle
              CircularProgressIndicator(
                value: progress / 100,
                strokeWidth: getWidth(context, 2),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF099AA8)),
              ),
              // Center Number
              Center(
                child: Text(
                  isTop ? date.day.toString() : day[0], // Highlight date on Monday
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
     
      ],
    );
  }
}