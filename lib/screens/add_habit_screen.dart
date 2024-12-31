import 'package:cogniosis/models/habit.dart';
import 'package:cogniosis/providers/habit_provider.dart';
import 'package:flutter/material.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:provider/provider.dart';


class AddHabitScreen extends StatefulWidget {
  final bool isDarkMode;

  const AddHabitScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String _selectedSlot = '';
  final List<bool> _selectedDays = List.generate(7, (_) => false);


  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().split(' ')[0];
    _timeController.text = "";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Code that requires context
  }

  @override
  Widget build(BuildContext context) {
      final HabitProvider _habitProvider = Provider.of<HabitProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF0D1314) : Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    Text(
                      'Add Habit',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getHeight(context, 30)),

              // Habit Name TextField
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20)),
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                    fontSize: getHeight(context, 16),
                    fontFamily: 'Satoshi',
                  ),
                  decoration: InputDecoration(
                    hintText: 'habit name',
                    hintStyle: TextStyle(
                      color: widget.isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                    ),
                    filled: true,
                    fillColor: widget.isDarkMode ? Color(0xFF292B2A) : Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 20)),

              // Date and Time Input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _dateController,
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: getHeight(context, 16),
                        fontFamily: 'Satoshi',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Select date',
                        hintStyle: TextStyle(
                          color: widget.isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: widget.isDarkMode ? Color(0xFF292B2A) : Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _dateController.text = pickedDate.toString().split(' ')[0];
                          });
                        }
                      },
                    ),
                    SizedBox(height: getHeight(context, 20)),
                    Text(
                      'Time',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _timeController,
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: getHeight(context, 16),
                        fontFamily: 'Satoshi',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Select time',
                        hintStyle: TextStyle(
                          color: widget.isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: widget.isDarkMode ? Color(0xFF292B2A) : Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _timeController.text = pickedTime.format(context);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: getHeight(context, 20)),

              // Time Slots
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slots',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _buildSlotButton('Morning'),
                        SizedBox(width: 10),
                        _buildSlotButton('Evening'),
                        SizedBox(width: 10),
                        _buildSlotButton('Both'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: getHeight(context, 20)),

              // Days Selection
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Days',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDayButton('M', 0),
                        _buildDayButton('T', 1),
                        _buildDayButton('W', 2),
                        _buildDayButton('T', 3),
                        _buildDayButton('F', 4),
                        _buildDayButton('S', 5),
                        _buildDayButton('S', 6),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          height: getHeight(context, 56),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.5,
              colors: [Color(0xFF3CC7D4), Color(0xFF099AA8)],
              stops: [0.0, 1.0],
            ),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: ElevatedButton(
            onPressed: () => _createHabit(_habitProvider),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              'Add Habit',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlotButton(String slot) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedSlot == slot
              ? Color(0xFF3CC7D4)
              : (widget.isDarkMode ? Color(0xFF292B2A) : Colors.grey[300]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            _selectedSlot = slot;
          });
        },
        child: Text(
          slot,
          style: TextStyle(
            color: _selectedSlot == slot
                ? Colors.white
                : (widget.isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildDayButton(String day, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDays[index] = !_selectedDays[index];
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _selectedDays[index]
              ? Color(0xFF3CC7D4)
              : (widget.isDarkMode ? Color(0xFF292B2A) : Colors.grey[300]),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: _selectedDays[index]
                  ? Colors.white
                  : (widget.isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  void _createHabit(HabitProvider _habitProvider) {

    // Implement habit creation logic here
    if (_nameController.text.isEmpty || _selectedSlot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    print(_selectedDays);

    List<String> fullDayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    Habit habit = Habit(
      name: _nameController.text,
      time: _selectedSlot,
      days: _selectedDays.asMap().entries.map((entry) => entry.value ? fullDayNames[entry.key] : '').where((day) => day.isNotEmpty).toList(),
    );
    _habitProvider.addHabit(habit);
    // Create habit logic here
    Navigator.pop(context);
  }
} 