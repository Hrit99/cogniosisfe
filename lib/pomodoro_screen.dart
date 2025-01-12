// import 'package:cogniosis/add_task_screen.dart';
// import 'package:cogniosis/day_completion.dart';
// import 'package:cogniosis/dimensions.dart';
// import 'package:cogniosis/listing_widget.dart';
// import 'package:cogniosis/task_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PomodoroScreen extends StatelessWidget {
//   final bool isDarkMode;
//   final String title;

//   const PomodoroScreen(
//       {Key? key, required this.isDarkMode, required this.title})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);

//     // Transform the List<Task> into a Map<String, int>
//     final weekData = _transformTasksToWeekData(taskProvider.getWeekData());
//     print(weekData);
//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.network(
//                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/manstandingontop.jpeg', // Replace with your background image asset
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Positioned.fill(
//               child: Container(
//                 color: isDarkMode
//                     ? Colors.black.withOpacity(0.8)
//                     : Colors.white.withOpacity(0.8),
//               ),
//             ),
//             Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(
//                     right: getWidth(context, 200),
//                     left: getWidth(context, 10),
//                     top: getHeight(context, 30),
//                   ),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.arrow_back),
//                         color: isDarkMode ? Colors.white : Colors.black,
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                       Expanded(
//                         child: Text(
//                           title,
//                           style: TextStyle(
//                             color: isDarkMode ? Colors.white : Colors.black,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: getWidth(context, 0),
//                       vertical: getHeight(context, 10)),
//                   child: WeekProgressWidget(
//                     weekData: weekData,
//                   ),
//                 ),
//                 Container(
//                   width: getWidth(context, 362),
//                   margin:
//                       EdgeInsets.symmetric(vertical: getHeight(context, 20)),
//                   padding: EdgeInsets.all(getWidth(context, 30)),
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? Colors.black.withOpacity(0.7)
//                         : Colors.white.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.2)
//                           : Colors.black.withOpacity(0.2),
//                       style: BorderStyle.solid,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => AddTaskScreen(isDarkMode: isDarkMode)),
//                           );
//                         },
//                         icon: Icon(
//                           Icons.add_circle,
//                           color: Color(0xFF3CC7D4),
//                           size: getHeight(context, 40),
//                       ),
//                       ),
//                       SizedBox(height: getHeight(context, 10)),
//                       Text(
//                         'Add Task',
//                         style: TextStyle(
//                           color: isDarkMode ? Colors.white : Colors.black,
//                           fontSize: getHeight(context, 18),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: getHeight(context, 5)),
//                       Text(
//                         'Schedule your goals',
//                         style: TextStyle(
//                           color: isDarkMode
//                               ? Colors.white.withOpacity(0.7)
//                               : Colors.black.withOpacity(0.7),
//                           fontSize: getHeight(context, 14),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: getWidth(context, 20),
//                       vertical: getHeight(context, 10)),
//                   child: ListingWidget(
//                     heigthConstrain: 300,
//                     cardType: CardType.task,
//                     headerPresent: false,
//                     titlePresent: true,
//                     title: 'Upcoming Tasks',
//                     categories: ['All', 'Pending', 'Resolved'],
//                     selectedCategory: 'Pending',
//                     onCategorySelected: (category) {
//                     // Handle category selection
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Map<String, Map<String, Object>> _transformTasksToWeekData(List<Task> tasks) {
//     DateTime now = DateTime.now();
//     DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//     Map<String, Map<String, Object>> weekData = {
//       'Mon': {
//         "completed": 0,
//         "date": startOfWeek.toString(),
//       },
//       'Tue': {
//         "completed": 0,
//         "date": startOfWeek.add(Duration(days: 1)).toString(),
//       },
//       'Wed': {
//         "completed": 0,
//         "date": startOfWeek.add(Duration(days: 2)).toString(),
//       },
//       'Thur': {
//         "completed": 0,
//         "date": startOfWeek.add(Duration(days: 3)).toString(),
//       },
//       'Fri': {
//         "completed": 0,
//         "date": startOfWeek.add(Duration(days: 4)).toString(),
//       },
//       'Sat': {
//         "completed": 0,
//         "date": startOfWeek.add(Duration(days: 5)).toString(),
//       },
//       'Sun': {
//         "completed": 0,
//         "date": startOfWeek.add(Duration(days: 6)).toString(),
//       },
//     };

//     for (var task in tasks) {
//       final day = task.date.weekday;
//       print(task.title + " " + task.durationCompleted.inSeconds.toString() + " " + task.date.weekday.toString() + " " + task.duration.inSeconds.toString());
//       switch (day) {
//         case DateTime.monday:
//           weekData['Mon']!['completed'] = (weekData['Mon']!['completed']
//                   as int) +
//               ((task.durationCompleted.inSeconds / task.duration.inSeconds) *
//                       100)
//                   .toInt();

//           break;
//         case DateTime.tuesday:
//           weekData['Tue']!['completed'] = (weekData['Tue']!['completed']
//                   as int) +
//               ((task.durationCompleted.inSeconds / task.duration.inSeconds) *
//                       100)
//                   .toInt();
//           print(weekData['Tue']!['completed']);
//           break;
//         case DateTime.wednesday:
//           weekData['Wed']!['completed'] = (weekData['Wed']!['completed']
//                   as int) +
//               ((task.durationCompleted.inSeconds / task.duration.inSeconds) *
//                       100)
//                   .toInt();
//           print(weekData['Wed']!['completed']);
//           break;
//         case DateTime.thursday:
//           weekData['Thur']!['completed'] = (weekData['Thur']!['completed']
//                   as int) +
//               ((task.durationCompleted.inSeconds / task.duration.inSeconds) *
//                       100)
//                   .toInt();
//           break;
//         case DateTime.friday:
//           weekData['Fri']!['completed'] = (weekData['Fri']!['completed']
//                   as int) +
//               ((task.durationCompleted.inSeconds / task.duration.inSeconds) *
//                       100)
//                   .toInt();
//           break;
//         case DateTime.saturday:
//           weekData['Sat']!['completed'] = (weekData['Sat']!['completed']
//                   as int) +
//               ((task.durationCompleted.inSeconds / task.duration.inSeconds) *
//                       100)
//                   .toInt();
//           break;
//         case DateTime.sunday:
//           weekData['Sun']!['completed'] = (weekData['Sun']!['completed']
//                   as int) +
//               ((task.durationCompleted.inSeconds / task.duration.inSeconds) *
//                       100)
//                   .toInt();
//           break;
//         default:
//           break;
//       }
      
//       }

//     for (var entry in weekData.entries) {
//       int taskCount = tasks.where((task) => task.date.weekday == (DateTime.parse(entry.value['date'] as String)).weekday).length;
//       entry.value['completed'] =
//           ((entry.value['completed'] as int) / (taskCount > 0 ? taskCount : 1)).toInt();
//     }
//     return weekData;
//   }
// }



import 'package:flutter/material.dart';

class PomodoroScreen extends StatelessWidget {
  final bool isDarkMode;
  final String title;

  const PomodoroScreen({Key? key, required this.isDarkMode, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('This is a simple screen'),
      ),
    );
  }
}
