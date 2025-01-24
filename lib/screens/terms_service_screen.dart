import 'package:cogniosis/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermsOfServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Services', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),),
        backgroundColor: isDarkMode ? Color(0xFF0D1314) : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: isDarkMode ? Color(0xFF0D1314) : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Introduction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome to Cogniosis (the "App"), a mental health support application operated by [Company Name] ("we," "us," or "our"). By accessing or using Cogniosis, you agree to be bound by these Terms of Use ("Terms"). If you disagree with any part of these Terms, you may not access or use the App.',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '2. Definitions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '• "Service" refers to the Cogniosis application and all its features\n'
                '• "User" refers to any individual who accesses or uses the Service\n'
                '• "Subscription" refers to the paid access to the Service\n'
                '• "Content" refers to all materials and features available through the Service\n'
                '• "App Store" refers to Apple\'s App Store and Google Play Store\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '3. Eligibility',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '3.1. You must be at least 18 years old to use the Service.\n'
                '3.2. By using the Service, you represent and warrant that you have the legal capacity to enter into these Terms.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '4. Service Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '4.1. Cogniosis provides digital mental health support tools including but not limited to:\n'
                '- AI-powered voice therapy sessions (limited to 240 minutes per calendar month)\n'
                '- Text-based chat support\n'
                '- Mood tracking\n'
                '- Habit tracking\n'
                '- Pomodoro timer\n'
                '- Audio meditations\n'
                '- Sleep and relaxation audio content\n\n'
                '4.2. Voice AI Usage Limits\n'
                '- Users are allocated 240 minutes of voice AI therapy sessions per calendar month\n'
                '- Unused minutes do not roll over to the following month\n'
                '- The monthly allowance resets at the beginning of each calendar month\n'
                '- Usage is measured in one-minute increments\n'
                '- Users will be notified when approaching their monthly limit\n\n'
                '4.3. The Service is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of qualified health providers with any questions you may have regarding medical conditions.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                '5. Platform Availability and Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '5.1. App Stores\n'
                '- The App is available for download on iOS through the Apple App Store and on Android through Google Play Store\n'
                '- Your use of the App must comply with all applicable app store terms of service\n'
                '- Any purchases made through the App Stores are subject to the respective store\'s payment policies and terms\n\n'
                '5.2. Platform-Specific Terms\n\n'
                'For iOS Users:\n'
                '- These Terms are between you and [Company Name], not Apple\n'
                '- Apple has no obligation to provide maintenance or support for the App\n'
                '- In the event of any failure of the App to conform to warranties, you may notify Apple, and Apple may refund your purchase price\n'
                '- Apple is not responsible for addressing any claims related to the App\n'
                '- Apple is a third-party beneficiary of these Terms\n\n'
                'For Android Users:\n'
                '- These Terms are between you and [Company Name], not Google\n'
                '- Your use of the App must comply with Google Play\'s Terms of Service\n'
                '- Google is not responsible for providing support or addressing claims related to the App\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '6. User Accounts and Privacy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '6.1. Users may access the Service anonymously.\n'
                '6.2. You are responsible for maintaining the confidentiality of any account credentials.\n'
                '6.3. Our collection and use of personal information is governed by our Privacy Policy.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '7. Subscription and Payment Terms',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '7.1. Free Trial\n'
                '- The Service offers a 7-day free trial\n'
                '- Payment details are required to start the free trial\n'
                '- You will receive a notification 24 hours before the trial period ends\n'
                '- If you do not cancel before the trial ends, you will be automatically charged for the subscription\n\n'
                '7.2. Subscription Terms\n'
                '- The subscription fee is £10 per month\n'
                '- Payments are processed automatically on a monthly basis\n'
                '- All fees are non-refundable except where required by law\n'
                '- Subscriptions purchased through the App Store will be charged to your App Store account\n'
                '- Subscription auto-renewal may be turned off through your App Store account settings\n\n'
                '7.3. Cancellation\n'
                '- You may cancel your subscription at any time\n'
                '- For App Store purchases, cancellation must be done through your App Store account settings\n'
                '- Cancellation will take effect at the end of the current billing period\n'
                '- No partial refunds will be provided for unused periods\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '8. User Conduct',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '8.1. You agree not to:\n'
                '- Use the Service for any unlawful purpose\n'
                '- Attempt to gain unauthorized access to the Service\n'
                '- Interfere with or disrupt the Service\n'
                '- Share account access with others\n'
                '- Upload harmful content or malware\n'
                '- Attempt to circumvent the App Store payment systems\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '9. Intellectual Property',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '9.1. All content, features, and functionality of the Service are owned by [Company Name] and are protected by international copyright, trademark, and other intellectual property laws.\n'
                '9.2. Users may not reproduce, distribute, modify, create derivative works of, publicly display, publicly perform, republish, download, store, or transmit any materials from the Service without prior written consent.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '10. Technical Requirements and Updates',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '10.1. The App requires:\n'
                '- iOS [version number] or later for Apple devices\n'
                '- Android [version number] or later for Android devices\n'
                '- Stable internet connection for full functionality\n\n'
                '10.2. Updates\n'
                '- We may release updates to the App through the App Stores\n'
                '- Updates may be required to continue using the Service\n'
                '- You are responsible for installing updates and maintaining compatibility\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '11. Disclaimers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '11.1. The Service is provided "as is" and "as available" without any warranties of any kind.\n'
                '11.2. We do not guarantee that the Service will be uninterrupted, timely, secure, or error-free.\n'
                '11.3. The Service is not intended to replace professional medical or mental health treatment.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '12. Limitation of Liability',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '12.1. To the fullest extent permitted by law, [Company Name] shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from or related to your use of the Service.\n'
                '12.2. Our total liability for any claims arising under these Terms shall not exceed the amount you paid for the Service in the past 12 months.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '13. Modifications to the Service and Terms',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '13.1. We reserve the right to modify or discontinue the Service at any time without notice.\n'
                '13.2. We may revise these Terms at any time by posting an updated version. Your continued use of the Service after any changes constitutes acceptance of the modified Terms.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '14. Termination',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '14.1. We may terminate or suspend your access to the Service immediately, without prior notice or liability, for any reason.\n'
                '14.2. Upon termination, your right to use the Service will immediately cease.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '15. Governing Law and Jurisdiction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '15.1. These Terms shall be governed by and construed in accordance with the laws of the United Kingdom.\n'
                '15.2. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts of the United Kingdom.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '16. Contact Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'For questions about these Terms, please contact us at [contact information].\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '17. Severability',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If any provision of these Terms is found to be unenforceable or invalid, that provision shall be limited or eliminated to the minimum extent necessary so that these Terms shall otherwise remain in full force and effect.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}