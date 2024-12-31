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
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0D1314) : Colors.white,
      body: FutureBuilder<Map<String, Map<String, Object>>>(
        future: habitProvider.getWeekData(now),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error loading data'));
          } else {
            final weekData = snapshot.data ?? {};
            print(weekData);
            return SingleChildScrollView(
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
                      vertical: getHeight(context, 10),
                    ),
                    child: WeekProgressWidget(
                      weekData: weekData,
                      isTop: true,

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: habitProvider.getUniqueTimes().map((time) => Container(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: habitProvider.habits
                               .where((habit) => habit.time == time)
                               .map((habit) => FutureBuilder<Map<String, Map<String, Object>>>(
                                     future: habitProvider.getWeekDataForHabit(now, habit.name),
                                     builder: (context, habitSnapshot) {
                                       if (habitSnapshot.connectionState == ConnectionState.waiting) {
                                         return Center(child: Container());
                                       } else if (habitSnapshot.hasError) {
                                         print(habitSnapshot.error);
                                         return Center(child: Text('Error loading habit data'));
                                       } else {
                                         final habitWeekData = habitSnapshot.data ?? {};
                                         return Container(
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
                                                   time ?? 'Anytime', 
                                                   style: TextStyle(
                                                     fontSize: getHeight(context, 20),
                                                     fontFamily: 'Satoshi',
                                                     fontWeight: FontWeight.bold,
                                                     color: isDarkMode ? Colors.white : Colors.black,
                                                   ),
                                                 ),
                                                 Text(
                                                   habit.name,
                                                   style: TextStyle(
                                                     color: isDarkMode ? Colors.white : Colors.black,
                                                     fontWeight: FontWeight.bold,
                                                   ),
                                                 ),
                                                 WeekProgressWidget(
                                                   weekData: habitWeekData,
                                                   isTop: false,
                                                   name: habit.name,
                                                 ),
                                               ],
                                             ),
                                           ),
                                         );
                                       }
                                     },
                                   ))
                               .toList(),
                         ),
                       ),
                        ).toList()
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
} 