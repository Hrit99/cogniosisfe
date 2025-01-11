import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/media_item_screen.dart';
import 'package:cogniosis/media_player_screen.dart';
import 'package:cogniosis/task_screen.dart';
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
  final String description;
  final bool isFavourite;
  final List<String> mediaUrls;
  final Function(MediaItem) onFavouritePressed;

  MediaItem({
    required this.image,
    required this.title,
    required this.duration,
    required this.author,
    required this.description,
    required this.isFavourite,
    required this.onFavouritePressed,
    required this.mediaUrls,
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
  final double? heigthConstrain;
  final String? selectedCategory;

  const ListingWidget({
    Key? key,
    required this.cardType,
    this.mediaCardType,
    this.headerPresent = false,
    this.titlePresent = false,
    this.title,
    this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
    this.heigthConstrain = 250,
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
      selectedCategory = widget.selectedCategory ?? widget.categories[0];
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.titlePresent ? _buildTitle(themeProvider) : SizedBox(),
            (widget.cardType == CardType.media && widget.mediaCardType == MediaCardType.four) ? TextButton(
              onPressed: () {
                setState(() {
                  selectedCategory = selectedCategory == 'All' ? widget.selectedCategory! : 'All';
                });
              },
              child: Text( selectedCategory == 'All' ? 'View favourites' : 'View all', style: TextStyle(color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[400], fontFamily: 'Satoshi', fontSize: getHeight(context, 14), fontWeight: FontWeight.w500),),
            ) : SizedBox(),
             (widget.cardType == CardType.task) ? TextButton(
              onPressed: () {
                setState(() {
                  selectedCategory = selectedCategory == 'All' ? widget.selectedCategory! : 'All';
                });
              },
              child: Text( selectedCategory == 'All' ? 'View Pending' : 'See all', style: TextStyle(color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[400], fontFamily: 'Satoshi', fontSize: getHeight(context, 14), fontWeight: FontWeight.w500),),
            ) : SizedBox(),
          ],
        ),
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
      return FutureBuilder(
        future: taskProvider.loadTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading tasks'));
          } else {
            return _buildTaskCard(themeProvider, taskProvider);
          }
        },
      );
    } else {
      return _buildMediaCard(themeProvider, musicProvider, videoProvider, exerciseProvider);
    }
  }

  Widget _buildTaskCard(ThemeProvider themeProvider, TaskProvider taskProvider) {
    final tasks = taskProvider.getTasksByCategory(selectedCategory);
    if (tasks.isEmpty) {
      return Container(
        padding: EdgeInsets.all(getWidth(context, 10)),
        margin: EdgeInsets.symmetric(vertical: getHeight(context, 4)),
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No tasks to show',
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              fontSize: getHeight(context, 18),
              fontWeight: FontWeight.bold,
              fontFamily: 'Satoshi',
            ),
          ),
        ),
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: getHeight(context, widget.heigthConstrain!), // Constrain the height
      ),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          bool isnotChecked = !task.isCompleted;
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(getWidth(context, 10)),
                margin: EdgeInsets.symmetric(vertical: getHeight(context, 4)),
                decoration: BoxDecoration(
                  color: isnotChecked 
                      ? (themeProvider.isDarkMode ? Colors.grey[800] : Colors.white) 
                      : Color(0xFF099AA8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isnotChecked = !isnotChecked;
                          taskProvider.toggleTaskCompletion(task);
                        });
                      },
                      child: Container(
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
                              color: themeProvider.isDarkMode ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.7),
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
                    ),
                    SizedBox(width: getWidth(context, 12)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskScreen(task: task),
                          ),
                        );
                      },
                      child: Container(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(task.image, height: getWidth(context, 72), width: getWidth(context, 72), fit: BoxFit.cover,),
                            ),
                        
                    SizedBox(width: getWidth(context, 20)),
                     Container(
                      width: getWidth(context, 200),
                      color: Colors.transparent,
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
                              '${task.duration.inMinutes} mins',
                              style: TextStyle(
                                color: isnotChecked && !themeProvider.isDarkMode ? Colors.black : Colors.white,
                                fontSize: getHeight(context, 12),
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${task.date.hour}:${task.date.minute} - ${task.date.day}/${task.date.month}/${task.date.year}',
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
                          ]
                        ), 
                      ),
                    ), 
                  ],
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
        return _buildMediaCardTypeTwo(themeProvider, musicProvider, videoProvider, selectedCategory);
      case MediaCardType.three:
        return _buildMediaCardTypeThree(themeProvider, musicProvider);
      case MediaCardType.four:
        return _buildMediaCardTypeFour(themeProvider, musicProvider, videoProvider, exerciseProvider);
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaItemScreen(mediaItem: mediaItem),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(mediaItem.image, height: getWidth(context, 187), width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
                  ),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MediaPlayerScreen(mediaItem: mediaItem),
                                  ),
                                );
                              },
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

  Widget _buildMediaCardTypeTwo(ThemeProvider themeProvider, MusicProvider musicProvider, VideoProvider videoProvider, selectedCategory) {
    final List<MediaItem> mediaItems =  selectedCategory == 'Music' ? musicProvider.getMusic() as List<MediaItem> : videoProvider.getVideos() as List<MediaItem>;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: getHeight(context, 300), // Constrain the height
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          final mediaItem = mediaItems[index];
          return Container(
            width: getWidth(context, 200),
            margin: EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle tap event
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaItemScreen(mediaItem: mediaItem),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(mediaItem.image, height: getWidth(context, 187), width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
                  ),
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
                            Container(
                              width: getWidth(context, 130),
                              child: Text(
                                mediaItem.title,
                                style: TextStyle(
                                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                                  fontSize: getHeight(context, 18),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Satoshi',
                                ),
                                overflow: TextOverflow.ellipsis,
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
                              onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MediaPlayerScreen(mediaItem: mediaItem),
                                  ),
                                );
                              },
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

  Widget _buildMediaCardTypeThree(ThemeProvider themeProvider, MusicProvider musicProvider) {
    final List<MediaItem> mediaItems = musicProvider.getMusic() ;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: getHeight(context, 500), // Constrain the height
      ),
      child: ListView.builder(
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          final mediaItem = mediaItems[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: getHeight(context, 10)),
            padding: EdgeInsets.symmetric(horizontal: getWidth(context, 10), vertical: getHeight(context, 15)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaItemScreen(mediaItem: mediaItem),
                      ),
                    );
                  },
                  child: Container(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(mediaItem.image, height: getWidth(context, 68), width: getWidth(context, 68), fit: BoxFit.cover,),
                        ),
                        SizedBox(width: getWidth(context, 10)),
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
                              SizedBox(height: getHeight(context, 5)),
                              Text(
                                mediaItem.duration,
                                style: TextStyle(
                                  color:  Color(0xFF828282),
                                  fontSize: getHeight(context, 12),
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w500,
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
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MediaPlayerScreen(mediaItem: mediaItem),
                                  ),
                                );
                              },
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

  Widget _buildMediaCardTypeFour(ThemeProvider themeProvider, MusicProvider musicProvider, VideoProvider videoProvider, ExerciseProvider exerciseProvider) {
   final List<MediaItem> mediaItems = selectedCategory == 'All' ? 
   [
    ...musicProvider.getMusic(),
    ...videoProvider.getVideos(),
    ...exerciseProvider.getExercises(),
   ]
   :
   [
     ...musicProvider.getMusic().where((item) => item.isFavourite),
     ...videoProvider.getVideos().where((item) => item.isFavourite),
     ...exerciseProvider.getExercises().where((item) => item.isFavourite),
   ];

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: getHeight(context, 500), // Constrain the height
      ),
      child: ListView.builder(
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          final mediaItem = mediaItems[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: getHeight(context, 10)),
            padding: EdgeInsets.symmetric(horizontal: getWidth(context, 10), vertical: getHeight(context, 15)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(mediaItem.image, height: getWidth(context, 68), width: getWidth(context, 68), fit: BoxFit.cover,),
                      ),
                      SizedBox(width: getWidth(context, 10)),
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
                            SizedBox(height: getHeight(context, 5)),
                            Text(
                              mediaItem.duration,
                              style: TextStyle(
                                color:  Color(0xFF828282),
                                fontSize: getHeight(context, 12),
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
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
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Container(
                          height: getHeight(context, 40),
                          width: getHeight(context, 40),
                          decoration: BoxDecoration(
                            // gradient: RadialGradient(
                            //   center: Alignment.center,
                            //   radius: 0.5,
                            //   colors: [
                            //     Color(0xFF3CC7D4),
                            //     Color(0xFF099AA8),
                            //   ],
                            //   stops: [0.0, 1.0],
                            // ),
                            color: themeProvider.isDarkMode ? Colors.black : Color(0xFFE0E0E0),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                mediaItem.onFavouritePressed(mediaItem);
                              },
                              icon: Icon(Icons.favorite, color: mediaItem.isFavourite ? Color(0xFF099AA8) : Color(0xFF828282),),
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
}