import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cogniosis/signup_screen.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cogniosis/task_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  VideoPlayerController? _controller;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    final file = await DefaultCacheManager().getSingleFile('https://aizenstorage.s3.us-east-1.amazonaws.com/login.mp4');
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
        _controller?.play(); // Auto-play the video
        _controller?.setLooping(true); // Loop the video
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Get user details
      final User? user = userCredential.user;

      if (user != null) {
        // Check if user is already registered in your database
        final response = await http.post(
          Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': user.email ?? '',
            'social_id': user.uid,
            'provider': 'google',
          }),
        );

        if (response.statusCode == 200) {
          // Store the access token
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', googleAuth?.accessToken ?? '');

          // Fetch tasks and navigate
          await _fetchTasksAndNavigate();
        } else {
          // Handle error
          print('Failed to log in or register user: ${response.body}');
        }
      }
    } catch (e) {
      // Handle error
      print('Error logging in with Google: $e');
    }
  }

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', responseData['access_token']);

      // Fetch tasks and navigate
      await _fetchTasksAndNavigate();
    } else {
      // Handle error
      print('Failed to log in: ${response.body}');
    }
  }

  Future<void> _fetchTasksAndNavigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      final response = await http.get(
        Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/tasks'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> taskData = jsonDecode(response.body);
        final List<Task> tasks = taskData.map((data) {
          return Task(
            id: data['id'],
            title: data['title'],
            duration: _parseDuration(data['duration']),
            date: DateTime.parse(data['date']),
            image: data['image'],
            durationCompleted: _parseDuration(data['duration_completed']),
            isCompleted: data['is_completed'],
            note: data['note'],
          );
        }).toList();

        // Update TaskProvider
        Provider.of<TaskProvider>(context, listen: false).setTasks(tasks);

        // Navigate to the HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Handle error
        print('Failed to fetch tasks: ${response.body}');
      }
    }
  }

  Duration _parseDuration(String duration) {
    final parts = duration.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _controller != null && _controller!.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                )
              : Center(child: SizedBox.expand(
                child: Container(
                  color: Colors.black,
                ),
              )),
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
                    onPressed: _login,
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
                      _socialLoginButton('G', onTap: _loginWithGoogle),
                      SizedBox(width: 16),
                      _socialLoginButton('', icon: Icons.apple, onTap: () {}),
                      SizedBox(width: 16),
                      _socialLoginButton('f', onTap: () {}),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Sign up text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          // backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
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
                    ],
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
