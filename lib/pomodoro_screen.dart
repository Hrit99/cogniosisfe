import 'package:cogniosis/add_task_screen.dart';
import 'package:cogniosis/day_completion.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/listing_widget.dart';
import 'package:cogniosis/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekData {
  final String day;
  int completed;
  final String date;

  WeekData({
    required this.day,
    required this.completed,
    required this.date,
  });
}

class PomodoroScreen extends StatelessWidget {
  final bool isDarkMode;
  final String title;

  const PomodoroScreen(
      {Key? key, required this.isDarkMode, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    List<Task> tasks = taskProvider.getWeekData();

    // Transform the List<Task> into a List<WeekData>
    final weekDataList = _transformTasksToWeekData(tasks);

    // Convert List<WeekData> to Map<String, Map<String, Object>>
    final weekDataMap = {
      for (var data in weekDataList)
        data.day: {'completed': data.completed, 'date': data.date}
    };

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/manstandingontop.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.8)
                    : Colors.white.withOpacity(0.8),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: getWidth(context, 200),
                    left: getWidth(context, 10),
                    top: getHeight(context, 30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: isDarkMode ? Colors.white : Colors.black,
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context, 0),
                      vertical: getHeight(context, 10)),
                  child: WeekProgressWidget(
                    weekData: weekDataMap,
                  ),
                ),
                Container(
                  width: getWidth(context, 362),
                  margin:
                      EdgeInsets.symmetric(vertical: getHeight(context, 20)),
                  padding: EdgeInsets.all(getWidth(context, 30)),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.7)
                        : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.2),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddTaskScreen(isDarkMode: isDarkMode)),
                          );
                        },
                        icon: Icon(
                          Icons.add_circle,
                          color: Color(0xFF3CC7D4),
                          size: getHeight(context, 40),
                        ),
                      ),
                      SizedBox(height: getHeight(context, 10)),
                      Text(
                        'Add Task',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: getHeight(context, 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: getHeight(context, 5)),
                      Text(
                        'Schedule your goals',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black.withOpacity(0.7),
                          fontSize: getHeight(context, 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context, 20),
                      vertical: getHeight(context, 10)),
                  child: ListingWidget(
                    heigthConstrain: 300,
                    cardType: CardType.task,
                    headerPresent: false,
                    titlePresent: true,
                    title: 'Upcoming Tasks',
                    categories: ['All', 'Pending', 'Resolved'],
                    selectedCategory: 'Pending',
                    onCategorySelected: (category) {
                      // Handle category selection
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<WeekData> _transformTasksToWeekData(List<Task> tasks) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    List<WeekData> weekData = [
      WeekData(
          day: 'Mon',
          completed: 0,
          date: startOfWeek.toIso8601String().split('T')[0]),
      WeekData(
          day: 'Tue',
          completed: 0,
          date: startOfWeek.add(Duration(days: 1)).toIso8601String().split('T')[0]),
      WeekData(
          day: 'Wed',
          completed: 0,
          date: startOfWeek.add(Duration(days: 2)).toIso8601String().split('T')[0]),
      WeekData(
          day: 'Thur',
          completed: 0,
          date: startOfWeek.add(Duration(days: 3)).toIso8601String().split('T')[0]),
      WeekData(
          day: 'Fri',
          completed: 0,
          date: startOfWeek.add(Duration(days: 4)).toIso8601String().split('T')[0]),
      WeekData(
          day: 'Sat',
          completed: 0,
          date: startOfWeek.add(Duration(days: 5)).toIso8601String().split('T')[0]),
      WeekData(
          day: 'Sun',
          completed: 0,
          date: startOfWeek.add(Duration(days: 6)).toIso8601String().split('T')[0]),
    ];

    for (var task in tasks) {
      final day = task.date.weekday;
      int completionPercentage = task.duration.inSeconds > 0
          ? ((task.durationCompleted.inSeconds / task.duration.inSeconds) * 100)
              .toInt()
          : 0;
      switch (day) {
        case DateTime.monday:
          weekData[0].completed += completionPercentage;
          break;
        case DateTime.tuesday:
          weekData[1].completed += completionPercentage;
          break;
        case DateTime.wednesday:
          weekData[2].completed += completionPercentage;
          break;
        case DateTime.thursday:
          weekData[3].completed += completionPercentage;
          break;
        case DateTime.friday:
          weekData[4].completed += completionPercentage;
          break;
        case DateTime.saturday:
          weekData[5].completed += completionPercentage;
          break;
        case DateTime.sunday:
          weekData[6].completed += completionPercentage;
          break;
        default:
          break;
      }
    }

    for (var data in weekData) {
      int taskCount = tasks
          .where((task) => task.date.weekday == (DateTime.parse(data.date)).weekday)
          .length;
      data.completed = (data.completed / (taskCount > 0 ? taskCount : 1)).toInt();
    }

    return weekData;
  }
}
