import 'package:cogniosis/login_screen.dart';
import 'package:cogniosis/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddTaskScreen extends StatefulWidget {
  final bool isDarkMode;

  const AddTaskScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? _selectedDate;
  final TextEditingController _nameController = TextEditingController();
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().split(' ')[0]; // Default to today's date
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _createTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString('access_token') ?? '';

    final url = Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/tasks');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'title': _nameController.text,
        'duration_seconds': _seconds + _minutes * 60 + _hours * 3600,
        'date': _dateController.text,
        'image': "assets/nebula.jpeg",
        'note': _noteController.text,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Task created successfully: ${responseData['task_id']}');
      Provider.of<TaskProvider>(context, listen: false).addTask(Task(
        id: responseData['task_id'],
        title: _nameController.text,
        duration: Duration(seconds: _seconds + _minutes * 60 + _hours * 3600),
        date: DateTime.parse(_dateController.text),
        note: _noteController.text,
        image: "assets/nebula.jpeg",
      ));
      Navigator.pop(context);
    } else {
      print('Failed to create task: ${response.body}');
      print(jsonDecode(response.body));
      if (jsonDecode(response.body)['msg']  == "Token has expired") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF0D1314) : Colors.grey[200],
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
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
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Add Task',
                          style: TextStyle(
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getHeight(context, 30)),
                // Add your additional widgets here
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20)),
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontSize: getHeight(context, 16),
                      fontFamily: 'Satoshi'
                    ),
                    decoration: InputDecoration(
                      hintText: 'name',
                      hintStyle: TextStyle(
                        color: widget.isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: widget.isDarkMode ? Color(0xFF292B2A) : Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 16)),
                    ),
                  ),
                ),
                SizedBox(height: getHeight(context, 20)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 10)),
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                          _dateController.text = _selectedDate.toString().split(' ')[0];
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dateController,
                        style: TextStyle(
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                          fontSize: getHeight(context, 16),
                          fontFamily: 'Satoshi'
                        ),
                        decoration: InputDecoration(
                          hintText: 'Set Date (e.g., 2023-12-31)',
                          hintStyle: TextStyle(
                            color: widget.isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                          ),
                          filled: true,
                          fillColor: widget.isDarkMode ? Color(0xFF292B2A) : Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 16)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getHeight(context, 20)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Hour',
                              style: TextStyle(
                                color: widget.isDarkMode ? Colors.white : Colors.black,
                                fontSize: getHeight(context, 16),
                                fontFamily: 'Satoshi'
                              ),
                            ),
                            SizedBox(height: getHeight(context, 5)),
                            Container(
                              height: getHeight(context, 100),
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 40,
                                diameterRatio: 1.2,
                                physics: FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  _hours = index;
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    return Center(
                                      child: Text(
                                        index.toString().padLeft(2, '0'),
                                        style: TextStyle(
                                          color: widget.isDarkMode ? Colors.white : Colors.black,
                                          fontSize: getHeight(context, 24),
                                          fontFamily: 'Satoshi'
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Minutes',
                              style: TextStyle(
                                color: widget.isDarkMode ? Colors.white : Colors.black,
                                fontSize: getHeight(context, 16),
                                fontFamily: 'Satoshi'
                              ),
                            ),
                            Container(
                              height: getHeight(context, 100),
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 40,
                                diameterRatio: 1.2,
                                physics: FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  _minutes = index;
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    return Center(
                                      child: Text(
                                        index.toString().padLeft(2, '0'),
                                        style: TextStyle(
                                          color: widget.isDarkMode ? Colors.white : Colors.black,
                                          fontSize: getHeight(context, 24),
                                          fontFamily: 'Satoshi'
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: 60,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Seconds',
                              style: TextStyle(
                                color: widget.isDarkMode ? Colors.white : Colors.black,
                                fontSize: getHeight(context, 16),
                                fontFamily: 'Satoshi'
                              ),
                            ),
                            Container(
                              height: getHeight(context, 100),
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 40,
                                diameterRatio: 1.2,
                                physics: FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  _seconds = index;
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    return Center(
                                      child: Text(
                                        index.toString().padLeft(2, '0'),
                                        style: TextStyle(
                                          color: widget.isDarkMode ? Colors.white : Colors.black,
                                          fontSize: getHeight(context, 24),
                                          fontFamily: 'Satoshi'
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: 60,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getHeight(context, 20)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 10)),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 3,
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontSize: getHeight(context, 16),
                      fontFamily: 'Satoshi'
                    ),
                      decoration: InputDecoration(
                      hintText: 'Add a note',
                      hintStyle: TextStyle(
                        color: widget.isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: widget.isDarkMode ? Color(0xFF292B2A) : Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Handle note input
                      });
                    },
                  ),
                ),
                // Add other fields and buttons as needed
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          height: getHeight(context, 56),
          width: getWidth(context, 362),
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
            onPressed: _createTask,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: Colors.transparent, // Transparent background
              shadowColor: Colors.transparent, // Remove shadow
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Add Task',
                style: TextStyle(color: widget.isDarkMode ? Colors.black : Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
