import 'package:cogniosis/checkin_summary.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/mood_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class CheckInScreen extends StatelessWidget {
  final bool isDarkMode;
  final String title;

  const CheckInScreen({Key? key, required this.isDarkMode, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/manstandingontop.jpeg', // Replace with your background image asset
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: isDarkMode ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8),
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
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(context, 30),
                    vertical: getHeight(context, 100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'What’s your mood today?',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: getHeight(context, 32),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Satoshi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: getHeight(context, 8)),
                      Text(
                        'Share your feelings with us by selecting the options based on your mood.',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                          fontSize: getHeight(context, 16),
                          fontFamily: 'Satoshi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: getHeight(context, 40)),
                    ],
                  ),
                ),
              ],
            ),

               Positioned(
                top: getHeight(context, 400),
                left: getWidth(context, 25),
                child: Container(
                  height: getWidth(context, 600),
                  width: getWidth(context, 600),
                  child: CircularTrapeziums(
                    circleRadius: getHeight(context, 130),
                  ),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
    );
  }
}

class TrapeziumPainter extends CustomPainter {
  final Color color;
  TrapeziumPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    // Define the radius for rounded corners
    const double radius = 7;

    final Path path = Path();

    // Start from the top-left corner
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0); // Top side
    path.quadraticBezierTo(
        size.width, 0, size.width, radius); // Top-right rounded corner

    path.lineTo(size.width * 0.75, size.height - radius); // Right slant side
    path.quadraticBezierTo(size.width * 0.72, size.height,
        size.width * 0.75 - radius, size.height);

    path.lineTo(
        size.width * 0.25 + radius, size.height); // Bottom-left rounded corner
    path.quadraticBezierTo(size.width * 0.28, size.height, size.width * 0.25,
        size.height - radius);

    path.lineTo(0, radius); // Left slant side
    path.quadraticBezierTo(0, 0, radius, 0); // Top-left rounded corner

    path.close();

    // Draw the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CircularTrapeziums extends StatelessWidget {
  const CircularTrapeziums({Key? key, required this.circleRadius})
      : super(key: key);
  final double circleRadius;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> moodDataList = [
         {
        'name': 'Happy',
        'color': Colors.amber,
        'icon': Icons.sentiment_very_satisfied
      },
      {
        'name': 'Worried',
        'color': Colors.grey[700]!,
        'icon': Icons.sentiment_very_dissatisfied
      },
      {'name': 'Angry', 'color': Colors.redAccent, 'icon': Icons.mood_bad},
      {
        'name': 'Refreshed',
        'color': Colors.lightBlue,
        'icon': Icons.sentiment_satisfied
      },
      {'name': 'Pained', 'color': Colors.brown, 'icon': Icons.sick},
      {'name': 'Silly', 'color': Colors.grey, 'icon': Icons.sentiment_neutral},
      {'name': 'Cool', 'color': Colors.teal, 'icon': Icons.emoji_emotions},
      {
        'name': 'Sad',
        'color': Colors.blueGrey,
        'icon': Icons.sentiment_dissatisfied
      },
      {
        'name': 'Wonderful',
        'color': Colors.purple,
        'icon': Icons.sentiment_very_satisfied
      },
      {'name': 'Tired', 'color': Colors.grey[600]!, 'icon': Icons.bedtime},
    ];

    const int trapeziumCount = 10; // Number of trapeziums

    return  Stack(
          alignment: Alignment.center,
          children: List.generate(trapeziumCount, (index) {
          // Calculate rotation angle for each trapezium
          final double angle = (index * 360 / trapeziumCount) * (math.pi / 180);

          return   Transform.translate(
            offset: Offset(
              circleRadius * -1 * (1 - math.cos(angle)),
              circleRadius * -1 * (1 - math.sin(angle)),
            ),
            child: Transform.rotate(
              angle: angle + 90 * (math.pi / 180),
              child: GestureDetector(
      onTap: () {
        print(moodDataList[index]['name']);
        Provider.of<MoodProvider>(context, listen: false).setMood(DateTime.now().toIso8601String().split('T').first, moodDataList[index]['name']);
        Navigator.push(context, MaterialPageRoute(builder: (context) => CheckInSummaryScreen()));
      },
      child:Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(getWidth(context, 100),
                          getHeight(context, 100)), // Width and Height
                      painter: TrapeziumPainter(
                          color: moodDataList[index]['color']!), // Pass color
                    ),
                   Transform.rotate(
                        angle: -(angle + 90 * (math.pi / 180)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              moodDataList[index]['icon'],
                              color: moodDataList[index]['color'],
                              size: 24.0,
                            ),
                            Text(
                              moodDataList[index]['name'],
                              style: TextStyle(
                                color: moodDataList[index]['color'],
                                fontSize: 7.0,
                              ),
                            ),
                          ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
        }),
    );
  }
}
