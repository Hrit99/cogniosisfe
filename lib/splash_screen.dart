import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/intro_screen.dart';
import 'package:cogniosis/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  final String videoUrl = 'https://aizenstorage.s3.us-east-1.amazonaws.com/splash.mp4'; // Replace with your video URL
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String accessToken = ''; // Replace with actual access token retrieval logic

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
    _initializeVideoPlayer();

    // Check access token and show dialog if blank
    if (accessToken.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showImportantNoticeDialog();
      });
    }
  }

  Future<void> _initializeVideoPlayer() async {
    final file = await DefaultCacheManager().getSingleFile(videoUrl);
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
        _controller?.play(); // Auto-play the video
        _controller?.setLooping(true); // Loop the video
        _animationController.forward(); // Start the fade-in animation
      });
  }

  void _showImportantNoticeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Important Notice'),
          content: Text(
            'This app is powered by artificial intelligence and is designed for self-reflection and emotional support only.\n\n'
            'It is not a substitute for professional medical advice, diagnosis, or treatment. If you\'re experiencing a mental health crisis, '
            'please contact a qualified healthcare provider or emergency services.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('I understand and agree'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller?.pause(); // Pause the video when navigating away
    super.deactivate();
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      _createFadeScaleRoute(IntroScreen1()),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      _createFadeScaleRoute(LoginScreen()),
    );
  }

  Route _createFadeScaleRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration(milliseconds: 4000),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curve,
          child: Transform.scale(
            scale: Tween<double>(begin: 1.1, end: 1.0)
                .animate(curve)
                .value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _controller != null && _controller!.value.isInitialized
              ? FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller!.value.size.width,
                        height: _controller!.value.size.height,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  ),
                )
              : SizedBox.expand(
                  child: Center(
                      child: Container(
                    color: Color(0xFF1D2122),
                  )),
                ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/splashscreenicon.png',
                    width: getWidth(context, 222),
                    height: getHeight(context, 65),
                  ),
                  SizedBox(
                      height: 16), // Add some space between the image and text
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(context, 45)),
                    child: Text(
                      'AI Mental Health Support App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'Satoshi',
                        fontSize: getWidth(context, 20),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        height: getHeight(context, 1.5),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 16), // Add some space between the image and text
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(context, 45)),
                    child: Text(
                      'Find peace, focus, and support anytime you need it.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            Color(0xFFFFFFFF), // Equivalent to var(--white, #FFF)
                        fontFamily: 'Satoshi',
                        fontSize: getWidth(context, 16),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        height: getHeight(context,
                            1.5), // Equivalent to line-height: 24px; 150%
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                      onPressed: () => _navigateToSignUp(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        shadowColor: Colors.transparent, // Remove shadow
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _navigateToLogin(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        shadowColor: Colors.transparent, // Remove shadow
                      ),
                      child: Container(
                        height: getHeight(context, 56),
                        width: getWidth(context, ((135 * 2) + 92)),
                        alignment: Alignment.center,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
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
}
