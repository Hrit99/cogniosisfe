import 'package:flutter/material.dart';

class CheckInSummaryApp extends StatelessWidget {
  const CheckInSummaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            "Check-in Summary",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
          leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        body: const CheckInSummaryScreen(),
      ),
    );
  }
}

class CheckInSummaryScreen extends StatelessWidget {
  const CheckInSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 20,
                  child: Icon(Icons.star, color: Colors.amber, size: 50),
                ),
                Positioned(
                  bottom: 20,
                  child: Text(
                    "25 Days",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Progress Section Title
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0),
          child: Text(
            "Progress",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Progress Lines
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7, // Seven lines for progress
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              );
            },
          ),
        ),

        // Footer (Days of the Week)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _dayWithIcon("Mon", true),
              _dayWithIcon("Tue", false),
              _dayWithIcon("Wed", false),
              _dayWithIcon("Thu", false),
              _dayWithIcon("Fri", false),
              _dayWithIcon("Sat", false),
              _dayWithIcon("Sun", false),
            ],
          ),
        ),
      ],
    );
  }

  // Footer day widget with smiley icon
  Widget _dayWithIcon(String day, bool hasIcon) {
    return Column(
      children: [
        if (hasIcon)
          const Icon(
            Icons.emoji_emotions,
            color: Colors.amber,
            size: 20,
          )
        else
          const SizedBox(height: 20),
        const SizedBox(height: 4),
        Text(
          day,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}