import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:cogniosis/providers/habit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekProgressWidget extends StatelessWidget {
  final Map<String, Map<String, Object>> weekData;
  final bool isTop;
  final String name;

  const WeekProgressWidget({Key? key, required this.weekData, this.isTop = true, this.name = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(weekData);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekData.entries.map((entry) {
        return _DayProgressCircle(  
          isTop: isTop,
          day: entry.key,
          progress: entry.value['completed'] as int,
          date: DateTime.parse(entry.value['date'] as String),
          name: name, 
          present: (entry.value['present'] as bool?) ?? true,
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
  final String name;
  final bool present;


  const _DayProgressCircle({Key? key, required this.day, required this.progress, required this.date, this.isTop = true, required this.name,  this.present = true})
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
        GestureDetector(
          onTap: isTop ? null : () async {
            // Define the action to be taken when the circle is clicked
            print('Circle clicked for day: $day');
            // String fullDayName;
            // switch (day) {
            //   case 'Mon':
            //     fullDayName = 'Monday';
            //     break;
            //   case 'Tue':
            //     fullDayName = 'Tuesday';
            //     break;
            //   case 'Wed':
            //     fullDayName = 'Wednesday';
            //     break;
            //   case 'Thur':
            //     fullDayName = 'Thursday';
            //     break;
            //   case 'Fri':
            //     fullDayName = 'Friday';
            //     break;
            //   case 'Sat':
            //     fullDayName = 'Saturday';
            //     break;
            //   case 'Sun': 
            //     fullDayName = 'Sunday';
            //     break;
            //   default:
            //     fullDayName = day;
            // }

            final habitProvider = Provider.of<HabitProvider>(context, listen: false);
            if (present) {
              final currentCompletion = await habitProvider.getHabitCompletedOnDay(date, name);
              print(currentCompletion);
              habitProvider.setHabitCompletedOnDay(date, name, currentCompletion ? false : true);
            }
            // final currentCompletion = habitProvider.getHabitCompletion(date.toString().split(' ')[0], name);
            // habitProvider.setHabitCompletion(date.toString().split(' ')[0], name, currentCompletion ? false : true);
            // Provider.of<HabitProvider>(context, listen: false).toggleHabit(name, fullDayName);
          },
          child: Container(
            height: getWidth(context, 40),
            width: getWidth(context, 40),
            decoration: BoxDecoration(
              color: isTop 
                ? Colors.transparent 
                : (present 
                    ? (date.isBefore(DateTime.now().add(Duration(days: 0))) 
                        ? (progress == 100 ? Colors.blue : Colors.red) 
                        : (isDarkMode ? Colors.transparent : Colors.white))
                    : Colors.transparent),
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
                  child: present ? Text(
                    isTop ? date.day.toString() : day[0], // Highlight date on Monday
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ) : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
     
      ],
    );
  }
}