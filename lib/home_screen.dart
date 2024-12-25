import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cogniosis/expandable_widget.dart'; // Import the expandable widget
import 'package:cogniosis/listing_widget.dart'; // Import the listing widget
// Import the task provider
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cogniosis/screens/profile_screen.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool isDarkMode) {
    if (_isDarkMode != isDarkMode) {
      _isDarkMode = isDarkMode;
      notifyListeners();
    }
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getSharedPreferences().then((prefs) {
      _initializeMonthDates(prefs);
    });
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  void _initializeMonthDates(SharedPreferences prefs) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final storedStartOfMonth = prefs.getString('month_start_date');
    final storedEndOfMonth = prefs.getString('month_end_date');

    if (storedStartOfMonth == null || storedEndOfMonth == null) {
      prefs.setString('month_start_date', startOfMonth.toIso8601String());
      prefs.setString('month_end_date', endOfMonth.toIso8601String());
    } else {
      final parsedStartOfMonth = DateTime.parse(storedStartOfMonth);
      final parsedEndOfMonth = DateTime.parse(storedEndOfMonth);

      if (now.isAfter(parsedEndOfMonth) || now.isBefore(parsedStartOfMonth)) {
        // Clear all shared preferences except 'access_token'
        final accessToken = prefs.getString('access_token');
        prefs.clear();
        if (accessToken != null) {
          prefs.setString('access_token', accessToken);
        }
        prefs.setString('month_start_date', startOfMonth.toIso8601String());
        prefs.setString('month_end_date', endOfMonth.toIso8601String());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<SharedPreferences>(
      future: _getSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading preferences'));
        } else {
          // Use prefs as needed
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/manstandingontop.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: themeProvider.isDarkMode
                      ? Colors.black.withOpacity(0.8)
                      : Colors.white.withOpacity(0.8), // Overlay color based on theme
                ),
                Positioned(
                  top: getHeight(context, 40),
                  left: getWidth(context, 20),
                  right: getWidth(context, 20),
                  bottom: 0, // Added bottom position to make the column scrollable
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(context, 0),
                        vertical: getHeight(context, 10)),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                themeProvider.isDarkMode
                                    ? 'assets/homelogodark.png'
                                    : 'assets/homelogo.png', // Replace with your image asset
                                height: getHeight(context, 37),
                                width: getWidth(context, 158),
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeProvider.isDarkMode
                                          ? Colors.grey[800]
                                          : Colors.white,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.notifications_none,
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                        // themeProvider.toggleTheme();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      width: getWidth(
                                          context, 10)), // Space between buttons
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeProvider.isDarkMode
                                          ? Colors.grey[800]
                                          : Colors.white,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.account_circle,
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                       Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                              height: getHeight(context, 1)), // Increased spacing

                          IconButton(
                            icon: Icon(
                              themeProvider.isDarkMode
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              // Add settings button functionality here
                              themeProvider.toggleTheme();
                            },
                          ),
                          SizedBox(
                              height: getHeight(
                                  context, 10)), // Additional spacing for text
                          Text(
                            'How are you feeling right now?',
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Satoshi',
                            ),
                          ),
                          SizedBox(
                              height: getHeight(
                                  context, 15)), // Additional spacing for widget
                          ExpandableButtonRow(), // Add the expandable widget here
                          SizedBox(
                              height: getHeight(
                                  context, 15)), // Spacing before search bar
                          Container(
                            decoration: BoxDecoration(
                              color: themeProvider.isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextField(
                              style: TextStyle(
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                  fontFamily: 'Satoshi',
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: themeProvider.isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: getWidth(context, 20),
                                  vertical: getHeight(context, 15),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: getHeight(
                                  context, 15)), // Spacing before listing widget
                          ListingWidget(
                            cardType: CardType.task,
                            headerPresent: true,
                            titlePresent: true,
                            title: 'Recently Added Tasks',
                            categories: ['All', 'Pending', 'Resolved'],
                            onCategorySelected: (category) {
                              // Handle category selection

                            },
                          ),
                          SizedBox(
                              height: getHeight(
                                  context, 15)), // Spacing before listing widget
                          ListingWidget(
                            cardType: CardType.media,
                            mediaCardType: MediaCardType.one,
                            headerPresent: true,
                            titlePresent: true,
                            title: 'Meditation',
                            categories: ['Music', 'Videos', 'Exercises'],
                            onCategorySelected: (category) {
                              // Handle category selection

                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
