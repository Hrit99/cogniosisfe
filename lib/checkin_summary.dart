import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:cogniosis/mood_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckInSummaryScreen extends StatelessWidget {

  const CheckInSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final moodProvider = Provider.of<MoodProvider>(context);
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final monthMood = moodProvider.getMonthMood(startOfMonth);

    monthMood.forEach((date, mood) {
      print('Date: $date, Mood: $mood');
    });
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0D1314) : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: isDarkMode ? Color(0xFF0D1314) : Colors.white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: getWidth(context, 20),
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
                          'Check-In Summary',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: getHeight(context, 20),
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
                    horizontal: getWidth(context, 20),
                    vertical: getHeight(context, 20),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: getHeight(context, 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/checkincard.png'), // Replace with your image asset path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // TeAdd more content here as needed
                Padding(padding: EdgeInsets.symmetric(horizontal: getWidth(context, 25), vertical: getHeight(context, 20)), child: Text('Progress', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: getHeight(context, 20), fontWeight: FontWeight.bold),),),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(context, 25)),
                    child: MoodChart(monthMood: monthMood, isDarkMode: isDarkMode),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MoodChart extends StatelessWidget {
  final Map<String, String> monthMood;
  final bool isDarkMode;

  MoodChart({required this.monthMood, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    List<String> days = [];
    List<List<String>> moods = [];

    for(int i = 1; i < 8; i++){
      String day = _getDayOfWeek(i);
      List<String> mood = monthMood.entries
              .where((entry) => DateTime.parse(entry.key).weekday == (i)) 
              .map((entry) => entry.value)
              .toList();
      days.add(day);
      moods.add(mood);
    }



    print('days: $days, moods: $moods');
  
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        height: getHeight(context, 280),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, kindex) {
            return Container(

              height: getHeight(context, 55),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(color: isDarkMode ? Colors.grey[700]! : Colors.black, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  while (moods[index].length < 7) {
                    moods[index].add('No mood set');
                  }
                  print('moods[index][index]: ${moods[index][kindex]}, days[index]: ${days[index]}');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Icon(
                    
                        _getMoodConfig(moods[index][kindex])['icon'],
                        color: _getMoodConfig(moods[index][kindex])['color'], 
                        size: getHeight(context, 40),
                      ),
                    ],
                  );
                }),
              ),
            );
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only( right: getWidth(context, 6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            return Text(
              days[index],
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300]! : Colors.black,
                fontSize: getHeight(context, 15),
                fontWeight: FontWeight.bold,
              ),
            );
          }),
        ),
      ),
    ],
  );
  }

  int _countOccurrences(int dayOfWeek) {
    return monthMood.keys
        .where((date) => DateTime.parse(date).weekday == dayOfWeek)
        .length;
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  Map<String, dynamic> _getMoodConfig(String mood) {
    switch (mood) {
      case 'Happy':
        return {'icon': Icons.sentiment_very_satisfied, 'color': Colors.amber};
      case 'Worried':
        return {'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.grey[700]};
      case 'Angry':
        return {'icon': Icons.mood_bad, 'color': Colors.redAccent};
      case 'Refreshed':
        return {'icon': Icons.sentiment_satisfied, 'color': Colors.lightBlue};
      case 'Pained':
        return {'icon': Icons.sick, 'color': Colors.brown};
      case 'Silly':
        return {'icon': Icons.sentiment_neutral, 'color': Colors.grey};
      case 'Cool':
        return {'icon': Icons.emoji_emotions, 'color': Colors.teal};
      case 'Sad':
        return {'icon': Icons.sentiment_dissatisfied, 'color': Colors.blueGrey};
      case 'Wonderful':
        return {'icon': Icons.sentiment_very_satisfied, 'color': Colors.purple};
      case 'Tired':
        return {'icon': Icons.bedtime, 'color': Colors.grey[600]};
      default:
        return {'icon': Icons.help_outline, 'color': Colors.transparent};
    }
  }

  double _getEmojiSize(String mood) {
    switch (mood) {
      case 'Happy':
        return 40.0;
      case 'Sad':
        return 20.0;
      case 'Neutral':
        return 30.0;
      default:
        return 10.0;
    }
  }
}
