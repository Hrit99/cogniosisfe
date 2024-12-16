import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cogniosis/signup_screen.dart';
import 'package:cogniosis/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late VideoPlayerController _controller;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/yogaman.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
        _controller.play(); // Auto-play the video
        _controller.setLooping(true); // Loop the video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _controller.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          Container(
            color: Colors.black.withOpacity(0.5), // Black tint overlay
          ),
          Positioned(
            top: 77.0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Visibility(
                     visible: MediaQuery.of(context).viewInsets.bottom == 0,
                     child: Column(
                       children: [
                         Image.asset(
                           'assets/splashscreenicon.png', // Replace with your image asset path
                           width: getWidth(context, 141), // Adjust the width as needed
                           height: getHeight(context, 44), // Adjust the height as needed
                           fit: BoxFit.cover,
                         ),
                         SizedBox(height: getHeight(context, getHeight(context, 10))),
                         Container(
                           width: getWidth(context, 92),
                           height: getHeight(context, 32),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(36),
                             color: Colors.white.withOpacity(0.0),
                           ),
                           child: Center(
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Image.asset('assets/circle-mic.png'),
                                 SizedBox(width: getWidth(context, 1)),
                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                  // Email Input
                  SizedBox(height: getHeight(context, 20)),
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Password Input
                  TextField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Sign In Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                      // Handle login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00A9B7),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Or sign in with text
                  Text(
                    'Or sign in with',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Social login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialLoginButton('G', onTap: () {}),
                      SizedBox(width: 16),
                      _socialLoginButton('', icon: Icons.apple, onTap: () {}),
                      SizedBox(width: 16),
                      _socialLoginButton('f', onTap: () {}),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Sign up text
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                        WidgetSpan(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupScreen()),
                              );
                            },
                            child: Text(
                              'Signup',
                              style: TextStyle(
                                color: Color(0xFF00A9B7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _socialLoginButton(String text, {IconData? icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: icon != null 
              ? Icon(icon, color: Colors.white, size: 24)
              
              : Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
