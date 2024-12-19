import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cogniosis/expandable_widget.dart'; // Import the expandable widget
import 'package:cogniosis/listing_widget.dart'; // Import the listing widget
// Import the task provider

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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/manstandingontop.jpeg')  ,
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
                                        // Add settings button functionality here
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
}
