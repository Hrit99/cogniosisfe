import 'dart:convert';

import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:cogniosis/screens/account_info_screen.dart';
import 'package:cogniosis/screens/help_centre_screen.dart';
import 'package:cogniosis/screens/privacy_policy_screen.dart';
import 'package:cogniosis/screens/reset_password_screen.dart';
import 'package:cogniosis/screens/terms_service_screen.dart';
import 'package:cogniosis/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),),
        backgroundColor: isDarkMode ? Color(0xFF0D1314) : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: isDarkMode ? Color(0xFF0D1314) : Colors.white,
      body: ListView(
        padding: EdgeInsets.all(getWidth(context, 16)),
        children: [
          _buildProfileOption(
            context,
            icon: Icons.account_circle,
            text: 'Account Information',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AccountInformationScreen()));
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.lock,
            text: 'Reset Password',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.notifications,
            text: 'Smart Notifications',
            onTap: () {},
          ),
          _buildProfileOption(
            context,
            icon: Icons.help,
            text: 'Help Centre',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCentreScreen()));
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.description,
            text: 'Terms of Services',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TermsOfServiceScreen()));
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.privacy_tip,
            text: 'Privacy Policy',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.share,
            text: 'Share App',
            onTap: () {},
          ),
          _buildProfileOption(
            context,
            icon: Icons.delete,
            text: 'Delete Account',
            onTap: () {
              _deleteAccount(context);
            },
          ),
          SizedBox(height: 20),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      height: getHeight(context, 65),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1D2122) : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.black, size: getHeight(context, 20),),
        title: Text(
          text,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: getHeight(context, 18),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : Colors.black, size: getHeight(context, 20),),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading preferences'));
        } else {
          final prefs = snapshot.data;
          return Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                GoogleSignIn().signOut();
                GoogleSignIn().disconnect();
                prefs?.remove('access_token');
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                // Add settings button functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3CC7D4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Reset'),
              onPressed: () {
                _resetPassword(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    final email = _emailController.text;
    final newPassword = _passwordController.text;

    if (email.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final url = Uri.parse(' /reset_password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'new_password': newPassword}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password: ${response.statusCode}')),
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final url = Uri.parse('/delete_account');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer ${await _getToken()}'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully')),
      );
      // Delete account from Google
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: ${response.statusCode}')),
      );
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}