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
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    int streak = 0;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0D1314) : Colors.white,
      body: FutureBuilder(
        future: moodProvider.loadMoodData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error loading mood data'));
          } else {
            final now = DateTime.now();
            final startOfMonth = DateTime(now.year, now.month, 1);
            final monthMood = moodProvider.getMonthMood(startOfMonth);

            // Calculate the mood streak
             streak = _calculateMoodStreak(moodProvider.moodData, now);
            print('Current mood streak: $streak days');

            return SafeArea(
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
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: getHeight(context, 130), bottom: getHeight(context, 10), left: getWidth(context, 100), right: getWidth(context, 100)),
                            decoration: BoxDecoration(
                              color: Color(0xFF099AA8), // Adjust the opacity as needed
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('$streak Days', style: TextStyle(color: isDarkMode ? Colors.black : Colors.white, fontSize: getHeight(context, 30), fontWeight: FontWeight.bold, fontFamily: 'Satoshi'), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: getWidth(context, 25), vertical: getHeight(context, 20)),
                        child: Text(
                          'Progress',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: getHeight(context, 20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
            );
          }
        },
      ),
    );
  }

  int _calculateMoodStreak(Map<String, String> moodData, DateTime now) {
    int streak = 0;
    DateTime currentDate = now;
    var sortedMoodDataEntries = moodData.entries.toList()
      ..sort((a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));
    moodData = Map.fromEntries(sortedMoodDataEntries);
     print(moodData);
     print(currentDate.toIso8601String().split('T').first);
    while (moodData.containsKey(currentDate.toIso8601String().split('T').first)) {
      streak++;
      currentDate = currentDate.subtract(Duration(days: 1));
    }

    return streak;
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
    int firstDay = 0;

       if (monthMood.isNotEmpty) {
        String firstKey = monthMood.keys.first;
         firstDay = DateTime.parse(firstKey).weekday;
       }

    for (int i = 1; i < 8; i++) {
      String day = _getDayOfWeek(i);
      List<String> mood = monthMood.entries
          .where((entry) => DateTime.parse(entry.key).weekday == (i))
          .map((entry) => entry.value)
          .toList();
      days.add(day);

   
      if(i < firstDay) {
        for (int j = 0; j < firstDay - 2; j++) {
          mood.insert(0, 'No mood set');
        }
      
      }
      moods.add(mood);
    }

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
                    // print(moods[index]);
                    while (moods[index].length < 7) {
                      moods[index].add('No mood set');
                    }

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
          padding: EdgeInsets.only(right: getWidth(context, 6)),
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
}
