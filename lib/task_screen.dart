import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:cogniosis/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskScreen extends StatefulWidget {
  final Task task;
  const TaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Duration totalTime;
  late Duration remainingTime;
  bool isRunning = false;
  late Stopwatch stopwatch;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    totalTime = widget.task.duration;
    remainingTime = totalTime - widget.task.durationCompleted;
    stopwatch = Stopwatch();
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (stopwatch.isRunning) {
        print("remainingTime: " + remainingTime.toString());
        setState(() {
          remainingTime = remainingTime - Duration(milliseconds: 100);
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void toggleTimer() {
    setState(() {
      if (isRunning) {
        stopwatch.stop();
      } else {
        stopwatch.start();
      }
      isRunning = !isRunning;
    });
  }

  Future<void> _createTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/tasks'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': task.id,
          'is_completed': task.isCompleted,
          'title': task.title,
          'duration_minutes': task.duration.inMinutes,
          'date': task.date.toIso8601String(),
          'image': task.image,
          'note': task.note,
        }),
      );

      if (response.statusCode == 201) {
        print('Task created successfully');
      } else {
        print('Failed to create task: ${response.body}');
      }
    }
  }

  Future<void> _updateTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      final response = await http.put(
        Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/tasks/${task.id}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'duration_completed_minutes': task.durationCompleted.inMinutes,
          'note': task.note,
          'is_completed': task.isCompleted,
        }),
      );

      if (response.statusCode == 200) {
        print('Task updated successfully');
      } else {
        print('Failed to update task: ${response.body}');
      }
    }
  }

  Future<void> _deleteTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      final response = await http.delete(
        Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/tasks/${task.id}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Task deleted successfully');
      } else {
        print('Failed to delete task: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // print(remainingTime);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.task.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: themeProvider.isDarkMode
                ? Colors.black.withOpacity(0.8)
                : Colors.white.withOpacity(0.8),
          ),
          Positioned(
            top: getHeight(context, 40),
            left: getWidth(context, 10),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () async {
                widget.task.durationCompleted = totalTime - remainingTime;
                await _updateTask(widget.task);
                Provider.of<TaskProvider>(context, listen: false).updateTask(widget.task);
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: getHeight(context, 230),
            left: getWidth(context, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: toggleTimer,
                  child: Container(
                    width: getWidth(context, 200),
                    height: getWidth(context, 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF099AA8),
                      boxShadow: [
                        BoxShadow(
                          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          offset: Offset(0, 0),
                          blurRadius: getWidth(context, 20),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.all(getWidth(context, 25)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeProvider.isDarkMode ?  Color(0xFF202020): Colors.white ,
                      ),
                      child:   Container(
                          margin: EdgeInsets.all(getWidth(context, 45)),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.5,
                              colors: [
                                Color(0xFF3CC7D4),
                                Color(0xFF099AA8),
                              ],
                              stops: [0.0, 1.0],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              isRunning ? Icons.pause : Icons.play_arrow,
                              color: themeProvider.isDarkMode ? Color(0xFF202020) : Colors.white,
                              size: getHeight(context, 40),
                            ),
                          ),
                        ),
                      ),
                  ),
                ),

                SizedBox(height: getHeight(context, 30)),
                Timetime(remainingTime: remainingTime, themeProvider: themeProvider),
                SizedBox(height: getHeight(context, 20)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.task.image,
                    height: 72,
                    width: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: getHeight(context, 10)),
                Text(
                  widget.task.title,
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: getHeight(context, 20),
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.task.duration.inMinutes} mins . ${widget.task.date.day}-${widget.task.date.month}-${widget.task.date.year}',
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? Color(0xFFBDBDBD) : Colors.black,
                    fontSize: getHeight(context, 12),
                    fontFamily: 'Satoshi',
                  ),
                ),
                SizedBox(height: getHeight(context, 40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: getWidth(context, 173),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.5,
                          colors: [
                            Color(0xFFE69092),
                            Color(0xFFBE3D40),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _deleteTask(widget.task);
                          Provider.of<TaskProvider>(context, listen: false).deleteTask(widget.task);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Delete',
                            style: TextStyle(color: themeProvider.isDarkMode ? Colors.black : Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getWidth(context, 20)),
                    Container(
                      width: getWidth(context, 173),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.5,
                          colors: [
                            Color(0xFF3CC7D4),
                            Color(0xFF099AA8),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          widget.task.isCompleted = true;
                          await _updateTask(widget.task);
                          Provider.of<TaskProvider>(context, listen: false).updateTask(widget.task);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Completed',
                            style: TextStyle(color: themeProvider.isDarkMode ? Colors.black : Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Timetime extends StatelessWidget {
  const Timetime({
    super.key,
    required this.remainingTime,
    required this.themeProvider,
  });

  final Duration remainingTime;
  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${remainingTime.inHours.toString().padLeft(2, '0')} : ${remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0')} : ${remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}',
      style: TextStyle(
        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Satoshi',
      ),
    );
  }
}
