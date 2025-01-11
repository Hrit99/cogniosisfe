import 'package:cogniosis/media_item_screen.dart';
import 'package:cogniosis/media_slider.dart';
import 'package:flutter/material.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:cogniosis/listing_widget.dart';

class MediaPlayerScreen extends StatefulWidget {
  final MediaItem mediaItem;

  const MediaPlayerScreen({Key? key, required this.mediaItem}) : super(key: key);

  @override
  _MediaPlayerScreenState createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  bool isPlaying = true;
  int currentTrackIndex = 0;
  final musicWaveKey = GlobalKey<MusicWaveWithAudioState>();
  final titleKey = GlobalKey<_MediaplayertitleState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Tint
          Positioned.fill(
            child: Image.network(
              widget.mediaItem.image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: themeProvider.isDarkMode ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                Padding(
                  padding: EdgeInsets.all(getWidth(context, 20)),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Mediaplayertitle(themeProvider: themeProvider, key: titleKey, title: (currentTrackIndex + 1).toString()),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Media Controls
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(getWidth(context, 20)),
                    margin: EdgeInsets.only(bottom: getHeight(context, 200)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title and Author
                        Text(
                          widget.mediaItem.title,
                          style: TextStyle(
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                            fontSize: getHeight(context, 24),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                        SizedBox(height: getHeight(context, 8)),
                        Text(
                          '${widget.mediaItem.duration} . ${widget.mediaItem.mediaUrls.length} tracks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context, 16),
                            fontFamily: 'Satoshi',
                          ),
                        ),
                        Text(
                          widget.mediaItem.author,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context, 16),
                            fontFamily: 'Satoshi',
                          ),
                        ),
                        SizedBox(height: getHeight(context, 8)),
                        IconRow(themeProvider: themeProvider, mediaItem: widget.mediaItem),
                        SizedBox(height: getHeight(context, 20)),

                        // Progress Slider
                        // SliderTheme(
                        //   data: SliderTheme.of(context).copyWith(
                        //     activeTrackColor: Colors.white,
                        //     inactiveTrackColor: Colors.white.withOpacity(0.3),
                        //     thumbColor: Colors.white,
                        //     trackHeight: getHeight(context, 4),
                        //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: getHeight(context, 8)),
                        //     overlayColor: Colors.white.withOpacity(0.2),
                        //     overlayShape: RoundSliderOverlayShape(overlayRadius: getHeight(context, 16)),
                        //   ),
                        //   child: Slider(
                        //     value: _currentSliderValue,
                        //     max: 100,
                        //     onChanged: (double value) {
                        //       setState(() {
                        //         _currentSliderValue = value;
                        //       });
                        //     },
                        //   ),
                        // ),

                        MusicWaveWithAudio(audioUrl: widget.mediaItem.mediaUrls[currentTrackIndex], key: musicWaveKey),

                        // Duration Labels
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0:00',
                                style: TextStyle(
                                  color: Color(0xFF828282),
                                  fontSize: getHeight(context, 12),
                                  fontFamily: 'Satoshi',
                                ),
                              ),
                              Text(
                                widget.mediaItem.duration,
                                style: TextStyle(
                                  color: Color(0xFF828282),
                                  fontSize: getHeight(context, 12),
                                  fontFamily: 'Satoshi',
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Playback Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.skip_previous),
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                              iconSize: getHeight(context, 40),
                              onPressed: () {
                                if (currentTrackIndex > 0) {
                                  currentTrackIndex--;
                                  musicWaveKey.currentState?.changeAudioUrl(widget.mediaItem.mediaUrls[currentTrackIndex]);
                                  titleKey.currentState?.changeTitle((currentTrackIndex + 1).toString());
                                }
                              },
                            ),
                            SizedBox(width: getWidth(context, 20)),
                            Container(
                              height: getHeight(context, 64),
                              width: getHeight(context, 64),
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
                              child: IconButton(
                                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                                color: Colors.white,
                                iconSize: getHeight(context, 32),
                                onPressed: () {
                                  if (isPlaying) {
                                    musicWaveKey.currentState?.pauseAudio();
                                  } else {
                                    musicWaveKey.currentState?.resumeAudio();
                                  }
                                  setState(() {
                                    isPlaying = !isPlaying;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: getWidth(context, 20)),
                            IconButton(
                              icon: Icon(Icons.skip_next),
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                              iconSize: getHeight(context, 40),
                              onPressed: () {
                                if (currentTrackIndex < widget.mediaItem.mediaUrls.length - 1) {
                                  currentTrackIndex++;
                                  musicWaveKey.currentState?.changeAudioUrl(widget.mediaItem.mediaUrls[currentTrackIndex]);
                                  titleKey.currentState?.changeTitle((currentTrackIndex + 1).toString());
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Mediaplayertitle extends StatefulWidget {
  const Mediaplayertitle({
    super.key,
    required this.themeProvider,
    required this.title
  });

  final ThemeProvider themeProvider;
  final String title;
  @override
  _MediaplayertitleState createState() => _MediaplayertitleState();
}

  extension _mediaplayertitleExtension on GlobalKey<_MediaplayertitleState> {
    void changeTitle(String newTitle) {
    currentState?.changeTitle(newTitle);
  }
}

class _MediaplayertitleState extends State<Mediaplayertitle> {
  String title = '';

  @override
  void initState() {
    super.initState();
    title = widget.title;
  }

  void changeTitle(String newTitle) {
    print("newTitle: $newTitle");
    setState(() {
      title = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Track - $title',
      style: TextStyle(
        color: widget.themeProvider.isDarkMode ? Colors.white : Colors.black,
        fontSize: getHeight(context, 20),
        fontWeight: FontWeight.bold,
        fontFamily: 'Satoshi',
      ),
      textAlign: TextAlign.center,
    );
  }
}
