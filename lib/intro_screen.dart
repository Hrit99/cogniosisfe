import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cogniosis/conveyor.dart';
import 'package:video_player/video_player.dart';
import 'package:cogniosis/login_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse('https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/womanoncall.mp4'))
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _changeVideo(String url) {
    _videoController.pause();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
                if (page == 1) {
                  _changeVideo('https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/womanoncall.mp4');
                } else if (page == 2) {
                  _changeVideo('https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/womanreading.mp4');
                }
              });
            },
            children: [
              _buildPageWithImage(context, 'Guided Meditation & Soothing Sounds', 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/some.jpeg', 'Explore a library of calming videos and audios designed for your well-being.'),
              _buildPageWithVideo(context, 'Chat & Call with AI Support', _videoController, "Our AI assistant is here to support you with thoughtful conversation and guidance"),
              _buildPageWithVideo(context, 'Pomodoro Task Scheduling', _videoController, "Set tasks, take mindful breaks, and stay on track with our Pomodoro feature"),
            ],
          ),
          Positioned(
            bottom: getHeight(context, 20),
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Redirect to another page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Text('Skip', style: TextStyle(color: Colors.white, fontSize: getHeight(context, 18), fontWeight: FontWeight.w400, fontFamily: 'Satoshi'),),
                  ),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return RadialGradient(
                        center: Alignment(0.0, 0.0),
                        radius: 0.5,
                        colors: [
                          Color(0xFF3CC7D4),
                          Color(0xFF099AA8),
                        ],
                        stops: [0.0, 1.0],
                      ).createShader(bounds);
                    },
                    child: ElevatedButton(
                      onPressed: _currentPage < 2
                          ? () {
                              _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(getHeight(context, 15)),
                        backgroundColor: Colors.white,
                        shadowColor: Color.fromRGBO(22, 25, 102, 0.08),
                        elevation: 6,
                      ).copyWith(
                        side: MaterialStateProperty.all(BorderSide.none),
                      ),
                      child: Icon(Icons.arrow_forward, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String text, Color color, String subtext) {
    return Stack(
      children: [
        Container(
          color: color,
        ),
        _buildBlackGradientOverlay(),
         Positioned(
          top: getHeight(context, 450), // Adjust this value to move the text down
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 32),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    height: getHeight(context, 44) / 32, // Equivalent to line-height: 44px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 10)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  subtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 18),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: getHeight(context, 22) / 16, // Equivalent to line-height: 22px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageWithImage(BuildContext context, String text, String imagePath, String subtext) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 100),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 100),
              height: 300,
              color: Colors.transparent,
              child: Column(
                children: [
                  ConveyorBeltWidget(
                    imageUrls: [
                      'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/fingeronwater.jpeg',
                      'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/meditationwhite.jpeg',
                      'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/flowerstem.jpeg',
                    ],
                    height: 100,
                    speedUp: false,
                  ),
                  SizedBox(height: 10),
                  ConveyorBeltWidget(
                    imageUrls: [
                      'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/backhandclap.jpeg',
                      'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/highleg.jpeg',
                      'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/manstandingontop.jpeg',
                    ],
                    height: 100,
                    speedUp: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildBlackGradientOverlay(),
        Positioned(
          top: getHeight(context, 450), // Adjust this value to move the text down
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 32),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    height: getHeight(context, 44) / 32, // Equivalent to line-height: 44px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 10)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  subtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 18),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: getHeight(context, 22) / 16, // Equivalent to line-height: 22px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageWithVideo(BuildContext context, String text, VideoPlayerController videoController, String subtext) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 100),
          child: VideoPlayer(videoController),
        ),
        _buildBlackGradientOverlay(),
        Positioned(
          top: getHeight(context, 450), // Adjust this value to move the text down
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 32),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    height: getHeight(context, 44) / 32, // Equivalent to line-height: 44px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 10)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  subtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 18),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: getHeight(context, 22) / 16, // Equivalent to line-height: 22px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlackGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.black,
            ],
            stops: [
              300 /
                  MediaQueryData.fromView(WidgetsBinding
                          .instance.platformDispatcher.views.first)
                      .size
                      .height,
              0.7
            ],
          ),
        ),
      ),
    );
  }
}

