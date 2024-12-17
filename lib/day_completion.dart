import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';

class WeekProgressWidget extends StatelessWidget {
  final Map<String, Map<String, Object>> weekData;

  const WeekProgressWidget({Key? key, required this.weekData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekData.entries.map((entry) {
        return _DayProgressCircle(
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

  const _DayProgressCircle({Key? key, required this.day, required this.progress, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Text(
          day,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
           const SizedBox(height: 5),
        SizedBox(
          height: getWidth(context, 40),
          width: getWidth(context, 40),
          child: Stack(
            children: [
              // Background Circle
              CircularProgressIndicator(
                value: 1, // full circle as background
                strokeWidth: getWidth(context, 2),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade800),
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
                  date.day.toString(), // Highlight date on Monday
                  style: TextStyle(
                    color: Colors.white,
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