import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/listing_widget.dart';
import 'package:cogniosis/media_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:dio/dio.dart'; // Add this import statement
import 'package:share_plus/share_plus.dart'; // Add this import statement
import 'package:path_provider/path_provider.dart'; // Add this import statement


class MediaItemScreen extends StatelessWidget {
  final MediaItem mediaItem;

  const MediaItemScreen({Key? key, required this.mediaItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: 
         Stack(
          children: [
          
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: getHeight(context, 261),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(mediaItem.image),
                        fit: BoxFit.cover,
              
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${mediaItem.duration} • ${mediaItem.mediaUrls.length} audios',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: getHeight(context, 12),
                          fontFamily: 'Satoshi',
                        ),
                      ),
                      IconRow(themeProvider: themeProvider, mediaItem: mediaItem),
                    ],
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 0)),
                  child: Text(
                  mediaItem.title,
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: getHeight(context, 20),
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                  ),
                 ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 0)),
                  child: Text(
                  mediaItem.author,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: getHeight(context, 12),
                    fontFamily: 'Satoshi',
                  ),
                  ),
                 ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 30)),
                  child:  Container(
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
                       borderRadius: BorderRadius.circular(24.0),
                     ),
                     child: ElevatedButton(
                       onPressed: () => {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MediaPlayerScreen(mediaItem: mediaItem),
                                  ),
                                )
                       },
                       style: ElevatedButton.styleFrom(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(24),
                         ),
                         backgroundColor: Colors.transparent, // Transparent background
                         shadowColor: Colors.transparent, // Remove shadow
                       ),
                       child: Container(
                        
                         alignment: Alignment.center,
                         child: Text(
                           'Play',
                           style: TextStyle(color: themeProvider.isDarkMode ? Colors.black : Colors.white),
                         ),
                       ),
                     ),
                   ),
                 ),

                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 0)),
                  child: Text(
                  mediaItem.description,
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? Color(0xFFE0E0E0) : Colors.black,
                    fontSize: getHeight(context, 16),
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w400,
                  ),
                  ),
                 ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Relevant Tags',
                        style: TextStyle(
                          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          fontSize: getHeight(context, 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: getHeight(context, 10)),
                      Wrap(
                        spacing: getWidth(context, 10),
                        runSpacing: getHeight(context, 0),
                        children: [
                          'Meditation',
                          'Breathing',
                          'Positive Thinking',
                          'Gratitude',
                          'Mindful Eating',
                          'Happiness',
                          'Music',
                        ].map((tag) {
                          return Chip(
                            padding: EdgeInsets.symmetric(horizontal: getWidth(context, 0), vertical: getHeight(context, 0)),
                            label: Text(tag),
                            backgroundColor: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelStyle: TextStyle(
                              color: Color(0xFF828282),
                              fontSize: getHeight(context, 14),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20), vertical: getHeight(context, 20)),
                  child:  ListingWidget(
                  titlePresent: true,
                  title: 'More From ${mediaItem.author}',
                  cardType: CardType.media,
                  mediaCardType: MediaCardType.three,
                  headerPresent: false,
                  authorFilter: mediaItem.author,
                  categories: ['Videos', 'Exercises', 'Favourites'],
                  onCategorySelected: (category) {
                  },
                )
                ),
                ],
              ),
            ),
              Positioned(
              top: getHeight(context, 35),
              left: getWidth(context, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode ? Colors.black.withOpacity(0.5)  : Color(0xFFE0E0E0).withOpacity(0.5), // Background color
                  shape: BoxShape.circle, // Make it circular
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: themeProvider.isDarkMode ? Colors.white : Colors.black,),
                ),
              ),
            ),
          ],
        ),
    );
  }
}

class IconRow extends StatefulWidget {
  const IconRow({
    super.key,
    required this.themeProvider,
    required this.mediaItem,
  });

  final ThemeProvider themeProvider;
  final MediaItem mediaItem;

  @override
  State<IconRow> createState() => _IconRowState();
}

class _IconRowState extends State<IconRow> {
  bool isFavourite = false;
  @override
  void initState() {
    // TODO: implement initState
    isFavourite = widget.mediaItem.isFavourite;
    super.initState();
  }

  Future<void> downloadFile(String url) async {
    try {
      var dio = Dio();
      var directory = await getApplicationDocumentsDirectory();
      var savePath = '${directory.path}/${url.split('/').last}';

      var response = await dio.download(url, savePath);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download completed: ${url.split('/').last}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download: ${url.split('/').last}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void downloadAllFiles() async {
    for (var url in widget.mediaItem.mediaUrls) {
      await downloadFile(url);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: getHeight(context, 40),
          width: getHeight(context, 40),
          decoration: BoxDecoration(
            color:  widget.themeProvider.isDarkMode ? Colors.black.withOpacity(0.5) : Color(0xFFE0E0E0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              icon: isFavourite ? Icon( Icons.favorite, color: Color(0xFF099AA8),) : Icon( Icons.favorite_border),
              color: isFavourite ? Color(0xFF099AA8) : widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
              onPressed: () {
                widget.mediaItem.onFavouritePressed(widget.mediaItem);
                setState(() {
                  isFavourite = !isFavourite;
                });
              },
              iconSize: getHeight(context, 20),
            ),
          ),
        ),
          Container(
          height: getHeight(context, 40),
          width: getHeight(context, 40),
          decoration: BoxDecoration(
            color:  widget.themeProvider.isDarkMode ? Colors.black.withOpacity(0.5) : Color(0xFFE0E0E0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              icon:  Icon( Icons.cloud_download_outlined),
              color: widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
              onPressed: downloadAllFiles,
              iconSize: getHeight(context, 20),
            ),
          ),
        ),
         Container(
          height: getHeight(context, 40),
          width: getHeight(context, 40),
          decoration: BoxDecoration(
            color:  widget.themeProvider.isDarkMode ? Colors.black.withOpacity(0.5) : Color(0xFFE0E0E0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              icon:  Icon( Icons.share),
              color: widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
              onPressed: () async {
                List<String> urls = widget.mediaItem.mediaUrls;
                String urlsString = urls.join('\n');
                await Share.share(
                  'Check out these audios:\n$urlsString',
                  subject: 'Audio Files',
                );
              },
              iconSize: getHeight(context, 20),
            ),
          ),
        ),
      ],
    );
  }
}
