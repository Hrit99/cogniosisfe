import 'package:cogniosis/day_completion.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/screens/add_habit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cogniosis/providers/habit_provider.dart';

class HabitScreen extends StatelessWidget {
  final bool isDarkMode;
  final String title;
  const HabitScreen({super.key, required this.isDarkMode, required this.title});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    print("jjj");
    print(habitProvider.habits[0].isActive);

    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    List<Widget> habitCompletionWidgets = [];

    for (int i = 0; i < habitProvider.habits.length; i++) {
      final habit = habitProvider.habits[i];
      List<Widget> dayWidgets = [];

      for (int day = 1; day <= endOfMonth.day; day++) {
        final date = DateTime(now.year, now.month, day);
        final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        final isCompleted = habitProvider.getHabitCompletion(formattedDate, habit.name);

        dayWidgets.add(Container(
          margin: EdgeInsets.all(2.0),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ));
      }

      habitCompletionWidgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(habit.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Row(children: dayWidgets),
          SizedBox(height: 10),
        ],
      ));
    }

    Map<String, Map<String, bool>> habitCompletionMap = {};

    for (int day = 1; day <= endOfMonth.day; day++) {
      final date = DateTime(now.year, now.month, day);
      final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      Map<String, bool> dailyHabits = {};

      for (int i = 0; i < habitProvider.habits.length; i++) {
        final habit = habitProvider.habits[i];
        final isCompleted = habitProvider.getHabitCompletion(formattedDate, habit.name);
        dailyHabits[habit.name] = isCompleted;
      }
      habitCompletionMap[formattedDate] = dailyHabits;
    }

    print(habitCompletionMap['2024-12-25']);

    // habitCompletionMap.forEach((date, habits) {
    //   print('Date: $date');
    //   habits.forEach((habit, isCompleted) {
    //     print('  Habit: $habit, Completed: $isCompleted');
    //   });
    // });

    // print(habitCompletionMap);

    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    Map<String, Map<String, Object>> weekData = {
      'Mon': {
        "completed": 0,
        "date": startOfWeek,
      },
      'Tue': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 1)),
      },
      'Wed': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 2)),
      },
      'Thur': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 3)),
      },
      'Fri': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 4)),
      },
      'Sat': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 5)),
      },
      'Sun': {
        "completed": 0,
        "date": startOfWeek.add(Duration(days: 6)),
      },
    };

    habitCompletionMap.forEach((date, habits) {
      DateTime habitDate = DateTime.parse(date);
      if (habitDate.isAfter(startOfWeek.subtract(Duration(days: 1))) && habitDate.isBefore(startOfWeek.add(Duration(days: 7)))) {
        int completedCount = habits.values.where((isCompleted) => isCompleted).length;
        int totalCount = habits.values.length;
        print(completedCount);
        print(totalCount);
        int completionPercentage = totalCount == 0 ? 0 : ((completedCount / totalCount) * 100).toInt();

        switch (habitDate.weekday) {
          case DateTime.monday:
            weekData['Mon']!['completed'] = completionPercentage;
            break;
          case DateTime.tuesday:
            weekData['Tue']!['completed'] = completionPercentage;
            break;
          case DateTime.wednesday:
            weekData['Wed']!['completed'] = completionPercentage;
            break;
          case DateTime.thursday:
            weekData['Thur']!['completed'] = completionPercentage;
            break;
          case DateTime.friday:
            weekData['Fri']!['completed'] = completionPercentage;
            break;
          case DateTime.saturday:
            weekData['Sat']!['completed'] = completionPercentage;
            break;
          case DateTime.sunday:
            weekData['Sun']!['completed'] = completionPercentage;
            break;
        }
      }
    });

    print(weekData);
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0D1314) : Colors.white,
      body: SingleChildScrollView(
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: getWidth(context, 20), top: getHeight(context, 70), bottom: getHeight(context, 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: isDarkMode ? Colors.white : Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: getHeight(context, 25), fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black, fontFamily: 'Satoshi'),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: isDarkMode ? Colors.white : Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddHabitScreen(isDarkMode: isDarkMode),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
           Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context, 0),
                      vertical: getHeight(context, 10)),
                  child: WeekProgressWidget(
                    weekData: weekData,
                    isTop: true,
                  ),
                ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: habitProvider.getUniqueTimes().map((time) =>          Container(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                      time ?? 'Anytime', 
                     style: TextStyle(
                       fontSize: getHeight(context, 20),
                       fontFamily: 'Satoshi',
                       fontWeight: FontWeight.bold,
                       color: isDarkMode ? Colors.white : Colors.black,
                     ),
                   ),
                   Column(
                     children: habitProvider.habits
                         .where((habit) => habit.time == time)
                         .map((habit) => Container(
                               margin: EdgeInsets.symmetric(vertical: 5.0),
                               width: double.infinity,
                               padding: EdgeInsets.symmetric(horizontal: getWidth(context, 10), vertical: getHeight(context, 20)),
                               decoration: BoxDecoration(
                                 color: isDarkMode ? Color(0xFF1D2122) : Colors.grey[200],
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               child: ListTile(
                                 title: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       habit.name,
                                       style: TextStyle(
                                         color: isDarkMode ? Colors.white : Colors.black,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),
                                     WeekProgressWidget(
                                       weekData: weekData,
                                       isTop: false,
                                       name: habit.name,
                                     ),
                                   ],
                                 ),
                               ),
                             ))
                         .toList(),
                   ),
                 ],
               ),
             ),
              ).toList()
          ),
        ),
        ]
        )
        
      ),
    );
  }
} 