import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cogniosis/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late VideoPlayerController _controller;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse('https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/yogaman.mp4'))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final response = await http.post(
      Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful signup
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Handle error
      print('Failed to sign up: ${response.body}');
    }
  }

  Future<void> _signUpWithGoogle() async {
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
        // Register user in your database
        final response = await http.post(
          Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': user.email ?? '',
            'username': user.displayName ?? '',
            'social_id': user.uid,
            'provider': 'google',
          }),
        );

        if (response.statusCode == 200) {
          // Store the access token
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', googleAuth?.accessToken ?? '');

          // Navigate to the HomeScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          // Handle error
          print('Failed to register user: ${response.body}');
        }
      }
    } catch (e) {
      // Handle error
      print('Error signing up with Google: $e');
    }
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
              : Center(child: SizedBox.expand(
                child: Container(
                  color: Colors.black,
                ),
              )),
          Container(
            color: Colors.black.withOpacity(0.5),
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
                          'assets/splashscreenicon.png',
                          width: getWidth(context, 141),
                          height: getHeight(context, 44),
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: getHeight(context, 10)),
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

                  // Name Input
                  SizedBox(height: getHeight(context, 20)),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),

                  // Email Input
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email address',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),

                  // Password Input
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),

                  // Confirm Password Input
                  SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Confirm password',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        onPressed: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword),
                      ),
                    ),
                  ),

                  // Sign Up Button
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00A9B7),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Or signup with text
                  SizedBox(height: 24),
                  Text(
                    'Or signup with',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),

                  // Social signup buttons
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialLoginButton('G', onTap: _signUpWithGoogle),
                      SizedBox(width: 16),
                      _socialLoginButton('', icon: Icons.apple, onTap: () {}),
                      SizedBox(width: 16),
                      _socialLoginButton('f', onTap: () {}),
                    ],
                  ),

                  // Sign in text
                  SizedBox(height: 24),
                     
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: TextStyle(color: Colors.white, fontSize: 14),),
                        TextButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        }, child: Text("Sign In", style: TextStyle(color: Color(0xFF00A9B7), fontWeight: FontWeight.w600,),))
                      ],
                     )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialLoginButton(String text,
      {IconData? icon, required VoidCallback onTap}) {
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
