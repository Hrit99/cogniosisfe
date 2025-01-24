import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:cogniosis/conveyor.dart';
import 'package:video_player/video_player.dart';
import 'package:cogniosis/login_screen.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class IntroScreen1 extends StatefulWidget {
  @override
  _IntroScreen1State createState() => _IntroScreen1State();
}

class _IntroScreen1State extends State<IntroScreen1> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            print('Dragging right');
            Navigator.pushReplacement(context, _createRoute(SplashScreen(), Offset(1, 0), slideLeft: false));
          } else if (details.primaryDelta! < 0) {
            print('Dragging left');
            Navigator.pushReplacement(context, _createRoute(IntroScreen2(), Offset(1, 0)));
          }
        },
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildPageWithImage(
                  context,
                  'Guided Meditation & Soothing Sounds',
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/some.jpeg',
                  'Explore a library of calming videos and audios designed for your well-being.'),
            ),
            Positioned(
              bottom: getHeight(context, 20),
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            _createRoute(LoginScreen(), Offset(-1, 0)));
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context, 18),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Satoshi'),
                      ),
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
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              _createRoute(IntroScreen2(), Offset(1, 0)));
                        },
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
      ),
    );
  }

  Widget _buildPageWithImage(
      BuildContext context, String text, String imagePath, String subtext) {
    return Stack(
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: EdgeInsets.only(bottom: 100),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
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
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ConveyorBeltWidget(
                      imageUrls: [
                        'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/fingeronwater.jpeg',
                        'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/meditationwhite.jpeg',
                        'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/flowerstem.jpeg',
                      ],
                      height: 100,
                      speedUp: false,
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ConveyorBeltWidget(
                      imageUrls: [
                        'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/backhandclap.jpeg',
                        'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/highleg.jpeg',
                        'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/manstandingontop.jpeg',
                      ],
                      height: 100,
                      speedUp: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildBlackGradientOverlay(),
        Positioned(
          top: getHeight(
              context, 450), // Adjust this value to move the text down
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 32),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    height: getHeight(context, 44) /
                        32, // Equivalent to line-height: 44px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 10)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  subtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 18),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: getHeight(context, 22) /
                        16, // Equivalent to line-height: 22px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 0 ? Colors.blue : Colors.grey,
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

  Route _createRoute(Widget page, Offset beginOffset, {bool slideLeft = true}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: slideLeft ? beginOffset : Offset(-beginOffset.dx, beginOffset.dy),
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class IntroScreen2 extends StatefulWidget {
  @override
  _IntroScreen2State createState() => _IntroScreen2State();
}

class _IntroScreen2State extends State<IntroScreen2>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  Future<void>? _initializeVideoPlayerFuture;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      final file = await DefaultCacheManager().getSingleFile('https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/intro2_resize.mp4');
      _videoController = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      )..setLooping(true);
      // Set a lower playback quality if needed
      _videoController.setPlaybackSpeed(1.0);
      
      _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
        if (mounted) {
          // Check if video was actually initialized
          if (_videoController.value.isInitialized) {
            setState(() {});
            _videoController.play();
          } else {
            print('Video controller initialized but video not ready');
            // Handle fallback
            _handleVideoError();
          }
        }
      }).catchError((error) {
        print('Error initializing video: $error');
        if (mounted) {
          _handleVideoError();
        }
      });
    } catch (e) {
      print('Error setting up video: $e');
      if (mounted) {
        _handleVideoError();
      }
    }
  }

  void _handleVideoError() {
    setState(() {
      // You might want to show a static image instead
      // or try loading a different format of the video
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _videoController.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            print('Dragging right');
            Navigator.pushReplacement(context, _createRoute(IntroScreen1(), Offset(1, 0), slideLeft: false));
          } else if (details.primaryDelta! < 0) {
            print('Dragging left');
            Navigator.pushReplacement(context, _createRoute(IntroScreen3(), Offset(1, 0)));
          }
        },
        child: Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Stack(children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                      ),
                      _buildPageWithVideo(
                          context,
                          'Chat & Call with AI Support',
                          _videoController,
                          "Our AI assistant is here to support you with thoughtful conversation and guidance",
                          2),
                    ]),
                  );
                } else {
                  return Center(
                      child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                  ));
                }
              },
            ),
            _buildBlackGradientOverlay(),
            Positioned(
              top: getHeight(
                  context, 450), // Adjust this value to move the text down
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                    child: Text(
                      'Chat & Call with AI Support',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(
                            0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                        fontFamily: 'Satoshi',
                        fontSize: getHeight(context, 32),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: getHeight(context, 44) /
                            32, // Equivalent to line-height: 44px; 137.5%
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight(context, 10)),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                    child: Text(
                      "Our AI assistant is here to support you with thoughtful conversation and guidance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(
                            0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                        fontFamily: 'Satoshi',
                        fontSize: getHeight(context, 18),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: getHeight(context, 22) /
                            16, // Equivalent to line-height: 22px; 137.5%
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight(context, 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        width: 5.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == 1 ? Colors.blue : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: getHeight(context, 20),
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            _createRoute(LoginScreen(), Offset(-1, 0)));
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context, 18),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Satoshi'),
                      ),
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
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              _createRoute(IntroScreen3(), Offset(1, 0)));
                        },
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
      ),
    );
  }

Widget _buildPageWithVideo(BuildContext context, String text,
    VideoPlayerController videoController, String subtext, int count) {
  return Stack(
    children: [
      Container(
        height: MediaQuery.of(context).size.height / 1.4,
        margin: EdgeInsets.only(bottom: 100),
        width: MediaQuery.of(context).size.width * 2, // Double the screen width
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: 0.0,
            maxWidth: MediaQuery.of(context).size.width * 2,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 2,
              height: MediaQuery.of(context).size.height / 1.4,
              child: VideoPlayer(videoController),
            ),
          ),
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

  Route _createRoute(Widget page, Offset beginOffset, {bool slideLeft = true}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero; 
        const curve = Curves.ease;

        var tween = Tween(
          begin: slideLeft ? beginOffset : Offset(-beginOffset.dx, beginOffset.dy),
          end: end,
        ).chain(CurveTween(curve: curve));
   
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class IntroScreen3 extends StatefulWidget {
  @override
  _IntroScreen3State createState() => _IntroScreen3State();
}

class _IntroScreen3State extends State<IntroScreen3>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  Future<void>? _initializeVideoPlayerFuture;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    final file = await DefaultCacheManager().getSingleFile('https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/intro3_resize.mp4');
    _videoController = VideoPlayerController.file(file)
      ..setLooping(true);
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      setState(() {});
      _videoController.play();
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _videoController.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            print('Dragging right');
            Navigator.pushReplacement(context, _createRoute(IntroScreen2(), Offset(1, 0), slideLeft: false));
          } else if (details.primaryDelta! < 0) {
            print('Dragging left');
            Navigator.pushReplacement(context, _createRoute(IntroScreen4(), Offset(1, 0)));
          }
        },
        child: Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildPageWithVideo(
                        context,
                        'Pomodoro Task Scheduling',
                        _videoController,
                        "Set tasks, take mindful breaks, and stay on track with our Pomodoro feature",
                        3),
                  );
                } else {
                  return Center(
                      child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                  ));
                }
              },
            ),
            _buildBlackGradientOverlay(),
            Positioned(
              top: getHeight(
                  context, 450), // Adjust this value to move the text down
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                    child: Text(
                      'Pomodoro Task Scheduling',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(
                            0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                        fontFamily: 'Satoshi',
                        fontSize: getHeight(context, 32),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: getHeight(context, 44) /
                            32, // Equivalent to line-height: 44px; 137.5%
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight(context, 10)),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                    child: Text(
                      "Set tasks, take mindful breaks, and stay on track with our Pomodoro feature",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(
                            0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                        fontFamily: 'Satoshi',
                        fontSize: getHeight(context, 18),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: getHeight(context, 22) /
                            16, // Equivalent to line-height: 22px; 137.5%
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight(context, 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        width: 5.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == 2 ? Colors.blue : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: getHeight(context, 20),
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            _createRoute(LoginScreen(), Offset(-1, 0)));
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context, 18),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Satoshi'),
                      ),
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
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              _createRoute(IntroScreen4(), Offset(1, 0)));
                        },
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
      ),
    );
  }

  Widget _buildPageWithVideo(BuildContext context, String text,
      VideoPlayerController videoController, String subtext, int count) {
    return Stack(
      children: [
        Container(
          height: count == 2 ? 200 : MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(bottom: 100),
          width: MediaQuery.of(context).size.width,
          child: VideoPlayer(videoController),
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

  Route _createRoute(Widget page, Offset beginOffset, {bool slideLeft = true}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: slideLeft ? beginOffset : Offset(-beginOffset.dx, beginOffset.dy),
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class IntroScreen4 extends StatefulWidget {
  @override
  _IntroScreen4State createState() => _IntroScreen4State();
}

class _IntroScreen4State extends State<IntroScreen4>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            print('Dragging right');
            Navigator.pushReplacement(context, _createRoute(IntroScreen3(), Offset(1, 0), slideLeft: false));
          } else if (details.primaryDelta! < 0) {
            print('Dragging left');
            Navigator.pushReplacement(context, _createRoute(IntroScreen5(), Offset(1, 0)));
          }
        },
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildPageWithImage(
                  context,
                  'Mood Tracker',
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/moodimg.jpg',
                  'Log your emotions, identify patterns, and gain insights into your mental well-being with our Mood Tracker feature.'),
            ),
            Positioned(
              bottom: getHeight(context, 20),
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            _createRoute(LoginScreen(), Offset(-1, 0)));
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context, 18),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Satoshi'),
                      ),
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
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              _createRoute(IntroScreen5(), Offset(1, 0)));
                        },
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
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildPageWithImage(
      BuildContext context, String text, String imagePath, String subtext) {
    return Stack(
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: EdgeInsets.only(bottom: 100),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
            ),
          ),
        ),
        // Positioned.fill(
        //   child: Align(
        //     alignment: Alignment.center,
        //     child: Container(
        //       margin: EdgeInsets.only(top: 100),
        //       height: 300,
        //       color: Colors.transparent,
        //       child: Column(
        //         children: [
        //           FadeTransition(
        //             opacity: _fadeAnimation,
        //             child: ConveyorBeltWidget(
        //               imageUrls: [
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/fingeronwater.jpeg',
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/meditationwhite.jpeg',
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/flowerstem.jpeg',
        //               ],
        //               height: 100,
        //               speedUp: false,
        //             ),
        //           ),
        //           SizedBox(height: 10),
        //           FadeTransition(
        //             opacity: _fadeAnimation,
        //             child: ConveyorBeltWidget(
        //               imageUrls: [
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/backhandclap.jpeg',
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/highleg.jpeg',
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/manstandingontop.jpeg',
        //               ],
        //               height: 100,
        //               speedUp: true,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        _buildBlackGradientOverlay(),
        Positioned(
          top: getHeight(
              context, 450), // Adjust this value to move the text down
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 32),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    height: getHeight(context, 44) /
                        32, // Equivalent to line-height: 44px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 10)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  subtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 18),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: getHeight(context, 22) /
                        16, // Equivalent to line-height: 22px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 3 ? Colors.blue : Colors.grey,
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

  Route _createRoute(Widget page, Offset beginOffset, {bool slideLeft = true}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: slideLeft ? beginOffset : Offset(-beginOffset.dx, beginOffset.dy),
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class IntroScreen5 extends StatefulWidget {
  @override
  _IntroScreen5State createState() => _IntroScreen5State();
}

class _IntroScreen5State extends State<IntroScreen5>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            print('Dragging right');
            Navigator.pushReplacement(context, _createRoute(IntroScreen4(), Offset(1, 0), slideLeft: false));
          } else if (details.primaryDelta! < 0) {
            print('Dragging left');
            Navigator.pushReplacement(context, _createRoute(IntroScreen6(), Offset(1, 0)));
          }
        },
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildPageWithImage(
                  context,
                  'Habit Tracker',
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/habitimgp.jpeg',
                  'Build positive routines, break bad habits, and stay consistent with our easy-to-use Habit Tracker.'),
            ),
            Positioned(
              bottom: getHeight(context, 20),
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            _createRoute(LoginScreen(), Offset(-1, 0)));
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context, 18),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Satoshi'),
                      ),
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
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              _createRoute(IntroScreen6(), Offset(1, 0)));
                        },
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
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildPageWithImage(
      BuildContext context, String text, String imagePath, String subtext) {
    return Stack(
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: EdgeInsets.only(bottom: 100),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
       
        _buildBlackGradientOverlay(),
        Positioned(
          top: getHeight(
              context, 450), // Adjust this value to move the text down
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 32),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    height: getHeight(context, 44) /
                        32, // Equivalent to line-height: 44px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 10)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  subtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 18),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: getHeight(context, 22) /
                        16, // Equivalent to line-height: 22px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 4 ? Colors.blue : Colors.grey,
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

  Route _createRoute(Widget page, Offset beginOffset, {bool slideLeft = true}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: slideLeft ? beginOffset : Offset(-beginOffset.dx, beginOffset.dy),
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}


class IntroScreen6 extends StatefulWidget {
  @override
  _IntroScreen6State createState() => _IntroScreen6State();
}

class _IntroScreen6State extends State<IntroScreen6>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            print('Dragging right');
            Navigator.pushReplacement(context, _createRoute(IntroScreen5(), Offset(1, 0), slideLeft: false));
          } else if (details.primaryDelta! < 0) {
            print('Dragging left');
            Navigator.pushReplacement(context, _createRoute(LoginScreen(), Offset(1, 0)));
          }
        },
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildPageWithImage(
                  context,
                  'Sleep and Relaxation',
                  'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/sleeprelax.webp',
                  'Track your sleep, unwind with guided exercises, and improve your rest with our Sleep & Relax tools.'),
            ),
            Positioned(
              bottom: getHeight(context, 20),
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            _createRoute(LoginScreen(), Offset(-1, 0)));
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context, 18),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Satoshi'),
                      ),
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
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              _createRoute(LoginScreen(), Offset(1, 0)));
                        },
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
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildPageWithImage(
      BuildContext context, String text, String imagePath, String subtext) {
    return Stack(
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: EdgeInsets.only(bottom: 100),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
            ),
          ),
        ),
        // Positioned.fill(
        //   child: Align(
        //     alignment: Alignment.center,
        //     child: Container(
        //       margin: EdgeInsets.only(top: 100),
        //       height: 300,
        //       color: Colors.transparent,
        //       child: Column(
        //         children: [
        //           FadeTransition(
        //             opacity: _fadeAnimation,
        //             child: ConveyorBeltWidget(
        //               imageUrls: [
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/fingeronwater.jpeg',
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/meditationwhite.jpeg',
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/flowerstem.jpeg',
        //               ],
        //               height: 100,
        //               speedUp: false,
        //             ),
        //           ),
        //           SizedBox(height: 10),
        //           FadeTransition(
        //             opacity: _fadeAnimation,
        //             child: ConveyorBeltWidget(
        //               imageUrls: [
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/backhandclap.jpeg',
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/highleg.jpeg',
        //                 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/manstandingontop.jpeg',
        //               ],
        //               height: 100,
        //               speedUp: true,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        _buildBlackGradientOverlay(),
        Positioned(
          top: getHeight(
              context, 450), // Adjust this value to move the text down
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 32),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    height: getHeight(context, 44) /
                        32, // Equivalent to line-height: 44px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 10)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 33)),
                child: Text(
                  subtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                    fontFamily: 'Satoshi',
                    fontSize: getHeight(context, 18),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: getHeight(context, 22) /
                        16, // Equivalent to line-height: 22px; 137.5%
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 3 ? Colors.blue : Colors.grey,
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

  Route _createRoute(Widget page, Offset beginOffset, {bool slideLeft = true}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: slideLeft ? beginOffset : Offset(-beginOffset.dx, beginOffset.dy),
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
