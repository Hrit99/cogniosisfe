import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:cogniosis/listing_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeditationScreen extends StatefulWidget {
  final bool isDarkMode;
  final String title;

  const MeditationScreen(
      {super.key, required this.isDarkMode, required this.title});

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  String selectedCategory = 'Music'; // Default category

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (widget.isDarkMode != themeProvider.isDarkMode) {
      themeProvider.toggleTheme();
    }
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF0D1314) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: getWidth(context, 12)), 
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Back Button and Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 0), vertical: getHeight(context, 10)),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: widget.isDarkMode ? Colors.white : Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
            
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: getWidth(context, 20),
                      vertical: getHeight(context, 10)),
                  decoration: BoxDecoration(
                    color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
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
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color:
                            widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontFamily: 'Satoshi',
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color:
                            widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: getWidth(context, 20),
                        vertical: getHeight(context, 15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getHeight(context, 10)),
                _buildCategoryNav(),
                SizedBox(height: getHeight(context, 10)),
                (selectedCategory == 'Music') ? ListingWidget(
                  titlePresent: true,
                  title: 'Recommended Audios',
                  cardType: CardType.media,
                  mediaCardType: MediaCardType.two,
                  headerPresent: false,
                  categories: ['Music', 'Videos', 'Exercises', 'Favourites'],
                  onCategorySelected: (category) {
                  },
                  ):SizedBox(),
                // Add your screen content here
                (selectedCategory == 'Music') ? ListingWidget(
                  titlePresent: true,
                  title: 'Top Trending Audios',
                  cardType: CardType.media,
                  mediaCardType: MediaCardType.three,
                  headerPresent: false,
                  categories: ['Videos', 'Exercises', 'Favourites'],
                  onCategorySelected: (category) {
                  },
                ):SizedBox(),
                selectedCategory == 'Videos' ? ListingWidget(
                  titlePresent: true,
                  title: 'Recommended Videos',
                  cardType: CardType.media,
                  mediaCardType: MediaCardType.two,
                  headerPresent: false,
                  selectedCategory: selectedCategory,
                  categories: ['Music', 'Exercises', 'Favourites'],
                  onCategorySelected: (category) {
                  },
                ):SizedBox(),
                selectedCategory == 'Videos' ? ListingWidget(
                  titlePresent: true,
                  title: 'Top Trending Videos',
                  cardType: CardType.media,
                  mediaCardType: MediaCardType.one,
                  headerPresent: false,
                  selectedCategory: selectedCategory,
                  categories: ['Music', 'Videos', 'Favourites'],
                  onCategorySelected: (category) {
                  },
                ):SizedBox(),
                selectedCategory == 'Exercises' ? ListingWidget(
                  titlePresent: true,
                  title: 'Recommended Exercises',
                  cardType: CardType.media,
                  mediaCardType: MediaCardType.one,
                  headerPresent: false,
                  selectedCategory: selectedCategory,
                  categories: ['Music', 'Videos', 'Favourites'],
                  onCategorySelected: (category) {
                  },
                ):SizedBox(),
                selectedCategory == 'Favourites' ? ListingWidget(
                  titlePresent: true,
                  title: 'Favourites',
                  cardType: CardType.media,
                  mediaCardType: MediaCardType.four,
                  headerPresent: false,
                  selectedCategory: selectedCategory,
                  categories: ['Music', 'Videos', 'Exercises'],
                  onCategorySelected: (category) {
                  },
                ):SizedBox(),
              ],
            ),
          ),
        ),
      ),
          );
  }

  Widget _buildCategoryNav() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            ["Music", "Videos", "Exercises", "Favourites"].map((category) {
          bool isSelected = selectedCategory == category;
          return Container(
            height: getHeight(context, 40),
            width: (MediaQuery.of(context).size.width / 1.1) /
                4, // Assuming 4 categories
            padding: EdgeInsets.symmetric(horizontal: getWidth(context, 0.5)),
            margin: EdgeInsets.symmetric(horizontal: getWidth(context, 0.5)),
            child: TextButton(
              onPressed: () {
                setState(() {
                  selectedCategory = category;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: isSelected
                    ? Color(0xFF099AA8)
                    : (widget.isDarkMode
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? (widget.isDarkMode ? Colors.black : Colors.white)
                      : Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Satoshi',
                  fontSize: getHeight(context, 14),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
