import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:cogniosis/screens/account_info_screen.dart';
import 'package:cogniosis/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
            onTap: () {},
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
            onTap: () {},
          ),
          _buildProfileOption(
            context,
            icon: Icons.description,
            text: 'Terms of Services',
            onTap: () {},
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
            onTap: () {},
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
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1D2122) : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
        title: Text(
          text,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : Colors.black),
        onTap: onTap,
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
                prefs?.clear();
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
}