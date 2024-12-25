import 'dart:convert';
import 'package:cogniosis/home_screen.dart';
import 'package:cogniosis/task_provider.dart';
import 'package:http/http.dart' as http;
import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:cogniosis/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  VideoPlayerController? _controller;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    final file = await DefaultCacheManager().getSingleFile('https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/login3_resize.mp4');
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
        _controller?.play();
        _controller?.setLooping(true);
      });
  }

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

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

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      // Handle successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Handle error
      _showSnackBar('Failed to sign up: ${response.body}');
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _loginWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });

      print("signing in with google");
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

      print("user: $user");
      if (user != null) {
        // Check if user is already registered in your database
        final response = await http.post(
          Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/email_login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': user.email ?? '',
          }),
        );

        if (response.statusCode == 200) {
          // Store the access token
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', responseData['access_token']);

          // Fetch tasks and navigate
          await _fetchTasksAndNavigate();
        } else {
          // Handle error
          _showSnackBar('Failed to log in or register user: ${response.body}');
        }
      }
    } catch (e) {
      // Handle error
      _showSnackBar('Error logging in with Google: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  Future<void> _fetchTasksAndNavigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    print("accessToken: $accessToken");
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
        _showSnackBar('Failed to fetch tasks: ${response.body}');
      }
    }
  }

  Future<void> _signUpWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Trigger the authentication flow
      print("signing in with google");
      await _signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        print('Google sign-in canceled');
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

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
          Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/signup'),
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
        print("response status code: ${response.statusCode}"); 
        if (response.statusCode == 201) {
          // Store the access token
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', googleAuth?.accessToken ?? '');

          _loginWithGoogle();
        } else {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          if (responseData['message'] == "User already exists") {
            _loginWithGoogle();
          } else {
            // Handle error
            _showSnackBar('Failed to register user: ${response.body}');
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase specific errors
      _showSnackBar('FirebaseAuthException: ${e.message}');
    } catch (e) {
      // Handle other errors
      _showSnackBar('Error signing up with Google: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16.0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
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
                  color: Colors.black.withOpacity(0.5),
                ),
                Positioned(
                  top: getHeight(context, 77),
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(context, 24)),
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
                          style: TextStyle(color: Colors.white, fontSize: getHeight(context, 12)),
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
                          style: TextStyle(color: Colors.white, fontSize: getHeight(context, 12)),
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
                          style: TextStyle(color: Colors.white, fontSize: getHeight(context, 12)),
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
                          style: TextStyle(color: Colors.white, fontSize: getHeight(context, 12)),
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
                            _socialLoginButton('', icon: Icons.apple, onTap: _signOut),
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
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            }, child: Text("Sign In", style: TextStyle(color: Color(0xFF00A9B7), fontWeight: FontWeight.w600,),))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
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
