import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:cogniosis/task_provider.dart';
import 'package:cogniosis/music_provider.dart';
import 'package:cogniosis/video_provider.dart';
import 'package:cogniosis/exercise_provider.dart';

enum CardType { task, media }
enum MediaCardType { one, two, three, four }

class MediaItem {
  final String image;
  final String title;
  final String duration;
  final String author;

  MediaItem({
    required this.image,
    required this.title,
    required this.duration,
      required this.author,
  });
}

class ListingWidget extends StatefulWidget {
  final CardType cardType;
  final MediaCardType? mediaCardType;
  final bool headerPresent;
  final bool titlePresent;
  final String? title;
  final List<String> categories;
  final Function(String) onCategorySelected;

  const ListingWidget({
    Key? key,
    required this.cardType,
    this.mediaCardType,
    this.headerPresent = false,
    this.titlePresent = false,
    this.title,
    required this.categories,
    required this.onCategorySelected,
  }) : assert(
          !titlePresent || (titlePresent && title != null),
          'Title must be provided when titlePresent is true',
        ),
        assert(
          cardType != CardType.media || mediaCardType != null,
          'mediaCardType must be provided when cardType is media',
        ),
        super(key: key);

  @override
  State<ListingWidget> createState() => _ListingWidgetState();
}

class _ListingWidgetState extends State<ListingWidget> {
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) {
      selectedCategory = widget.categories[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final musicProvider = Provider.of<MusicProvider>(context);
    final videoProvider = Provider.of<VideoProvider>(context);
    final exerciseProvider = Provider.of<ExerciseProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.titlePresent ? _buildTitle(themeProvider) : SizedBox(),
        widget.headerPresent
            ? Container(
                width: MediaQuery.of(context).size.width,
                child: _buildCategoryNav(themeProvider),
              )
            : SizedBox(),
        Container(
          margin: EdgeInsets.symmetric(vertical: getHeight(context, 7), horizontal: 0),
          decoration: BoxDecoration(
            // color: themeProvider.isDarkMode ? Colors.black.withOpacity(0.5) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            // boxShadow: [
            //   BoxShadow(
            //     color: themeProvider.isDarkMode ? Colors.black.withOpacity(0.1) : Colors.white.withOpacity(0.1),
            //     blurRadius: 8,
            //     offset: Offset(0, 2),
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardContent(themeProvider, taskProvider, musicProvider, videoProvider, exerciseProvider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryNav(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.categories.map((category) {
          bool isSelected = selectedCategory == category;
          return Container(
           
            height: getHeight(context, 40),
            width: (MediaQuery.of(context).size.width/1.1) / widget.categories.length,
            padding: EdgeInsets.symmetric(horizontal: getWidth(context, 5)),
            child: TextButton(
              onPressed: () {
                setState(() {
                  selectedCategory = category;
                });
                widget.onCategorySelected(category);
              },
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? Color(0xFF099AA8) : (themeProvider.isDarkMode ? Colors.black.withOpacity(0.5) : Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? (themeProvider.isDarkMode ? Colors.black : Colors.white) : Colors.grey,
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

  Widget _buildTitle(ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: getHeight(context, 10)),
      child: Text(
        widget.title!,
        style: TextStyle(
          fontFamily: 'Satoshi',
          fontSize: getHeight(context, 20),
          fontWeight: FontWeight.bold,
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildCardContent(ThemeProvider themeProvider, TaskProvider taskProvider, MusicProvider musicProvider, VideoProvider videoProvider, ExerciseProvider exerciseProvider) {
    if (widget.cardType == CardType.task) {
      return _buildTaskCard(themeProvider, taskProvider);
    } else {
      return _buildMediaCard(themeProvider, musicProvider, videoProvider, exerciseProvider);
    }
  }

  Widget _buildTaskCard(ThemeProvider themeProvider, TaskProvider taskProvider) {
    final tasks = taskProvider.getTasksByCategory(selectedCategory);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: getHeight(context, 250), // Constrain the height
      ),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          bool isnotChecked = !task.isCompleted;
          return StatefulBuilder(
            builder: (context, setState) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    isnotChecked = !isnotChecked;
                    taskProvider.toggleTaskCompletion(task);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(getWidth(context, 10)),
                  margin: EdgeInsets.symmetric(vertical: getHeight(context, 4)),
                  decoration: BoxDecoration(
                    color: isnotChecked 
                        ? (themeProvider.isDarkMode ? Colors.grey[800] : Colors.white) 
                        :  Color(0xFF099AA8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(getWidth(context, 8)),
                        width: getWidth(context, 20),
                        height: getWidth(context, 20),
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkMode && isnotChecked ? Colors.black.withOpacity(0.5) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF099AA8),
                            width: getWidth(context, 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeProvider.isDarkMode? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.7),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: !isnotChecked ? Icon(
                          Icons.check,
                          color: Color(0xFF099AA8),
                          size: getHeight(context, 15),
                        ) : SizedBox(),
                      ),
                      SizedBox(width: getWidth(context, 12)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(task.image, height: getWidth(context, 72), width: getWidth(context, 72), fit: BoxFit.cover,),
                      ),
                      SizedBox(width: getWidth(context, 20)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                color: isnotChecked && !themeProvider.isDarkMode ? Colors.black : Colors.white,
                                fontSize: getHeight(context, 18),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Satoshi',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              task.duration,
                              style: TextStyle(
                                color: isnotChecked && !themeProvider.isDarkMode ? Colors.black : Colors.white,
                                fontSize: getHeight(context, 12),
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              task.date,
                              style: TextStyle(
                                color: isnotChecked && !themeProvider.isDarkMode ? Colors.black : Colors.white,
                                fontSize: getHeight(context, 12),
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMediaCard(ThemeProvider themeProvider, MusicProvider musicProvider, VideoProvider videoProvider, ExerciseProvider exerciseProvider) {
    switch (widget.mediaCardType!) {
      case MediaCardType.one:
        return _buildMediaCardTypeOne(themeProvider, musicProvider, videoProvider, exerciseProvider);
      case MediaCardType.two:
        return _buildMediaCardTypeTwo();
      case MediaCardType.three:
        return _buildMediaCardTypeThree();
      case MediaCardType.four:
        return _buildMediaCardTypeFour();
    }
  }

  Widget _buildMediaCardTypeOne(ThemeProvider themeProvider, MusicProvider musicProvider, VideoProvider videoProvider, ExerciseProvider exerciseProvider) {
    final List<MediaItem> mediaItems = selectedCategory == 'Music'
        ? (musicProvider.getMusic() as List<MediaItem>)
        : selectedCategory == 'Videos'
            ? (videoProvider.getVideos() as List<MediaItem>)
            : (exerciseProvider.getExercises() as List<MediaItem>);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: getHeight(context, 600), // Constrain the height
      ),
      child: ListView.builder(
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          final mediaItem = mediaItems[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: getHeight(context, 13)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(mediaItem.image, height: getWidth(context, 187), width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
                ),
                SizedBox(height: getHeight(context, 10)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                mediaItem.title,
                              style: TextStyle(
                                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                                fontSize: getHeight(context, 18),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Satoshi',
                              ),
                            ),
                            Text(
                              mediaItem.author,
                              style: TextStyle(
                                color: themeProvider.isDarkMode ? Colors.white : Color(0xFF828282),
                                fontSize: getHeight(context, 14),
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                       Container(
                          height: getHeight(context, 40),
                          width: getHeight(context, 40),
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
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.play_arrow, color: themeProvider.isDarkMode ? Colors.black : Colors.white,),
                              iconSize: getHeight(context, 20),
                            ),
                          ),
                       ),
                      ],
                    ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaCardTypeTwo() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/placeholder.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/placeholder.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaCardTypeThree() {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/placeholder.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/placeholder.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/placeholder.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaCardTypeFour() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(4, (index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/placeholder.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        );
      }),
    );
  }
}