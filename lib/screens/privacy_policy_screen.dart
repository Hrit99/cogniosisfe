import 'package:cogniosis/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),),
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
                '[Company Name] ("we," "us," or "our") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our Cogniosis mobile application ("App"), available on iOS and Android platforms.\n\n'
                'We understand the sensitive nature of mental health information and have designed our privacy practices with this in mind. This policy complies with the UK Data Protection Act 2018, the UK GDPR, and other applicable privacy laws.',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '2. Information We Collect',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '2.1 Information You Provide\n\n'
                'While using our App anonymously, we may collect:\n'
                '- Voice recordings from AI therapy sessions\n'
                '- Chat messages with our AI assistant\n'
                '- Mood tracking data\n'
                '- Habit tracking information\n'
                '- App preferences and settings\n'
                '- Subscription and payment information (processed through Apple App Store or Google Play Store)\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '2.2 Automatically Collected Information\n\n'
                'We automatically collect:\n'
                '- Device information (type, model, operating system)\n'
                '- App usage statistics\n'
                '- Error logs and performance data\n'
                '- IP address\n'
                '- Time zone and language preferences\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '2.3 Anonymous Use\n\n'
                'Our App is designed to provide anonymous access. We do not require personal identification information to use the service. However, to process payments, the respective app stores may collect payment information according to their privacy policies.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '3. How We Use Your Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We use collected information for:\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '3.1 Service Provision\n'
                '- Delivering AI therapy and chat support\n'
                '- Processing and storing mood and habit tracking data\n'
                '- Providing meditation and relaxation audio content\n'
                '- Managing your subscription\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '3.2 Service Improvement\n'
                '- Analyzing usage patterns to improve features\n'
                '- Identifying and fixing technical issues\n'
                '- Developing new features\n'
                '- Training and improving our AI systems\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '3.3 Communication\n'
                '- Sending service-related notifications\n'
                '- Providing subscription status updates\n'
                '- Responding to your inquiries\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '4. Data Storage and Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '4.1 Data Storage\n'
                '- All data is stored on secure servers located in the [Location/Region]\n'
                '- Voice recordings and chat logs are encrypted in transit and at rest\n'
                '- Mood and habit tracking data is stored securely with encryption\n'
                '- We implement appropriate technical and organizational measures to protect your data\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '4.2 Data Retention\n'
                '- Active account data is retained while your account is active\n'
                '- Voice recordings are automatically deleted after [X] days\n'
                '- Chat logs are retained for [X] days\n'
                '- You can request deletion of your data at any time\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '4.3 Security Measures\n'
                '- End-to-end encryption for voice and chat communications\n'
                '- Regular security audits and assessments\n'
                '- Strict access controls and authentication measures\n'
                '- Continuous monitoring for potential security threats\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '5. Data Sharing and Disclosure',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '5.1 We Do Not Sell Your Data\n'
                'We do not sell, trade, or rent your personal information to third parties.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '5.2 Limited Sharing\n'
                'We may share your information with:\n'
                '- Service providers who assist in operating our App\n'
                '- App stores for payment processing\n'
                '- Law enforcement when required by law\n'
                '- Professional advisers in connection with corporate transactions\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '5.3 Anonymous Data\n'
                'We may share anonymous, aggregated data for research, analysis, or statistical purposes.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '6. Your Rights and Choices',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'You have the right to:\n'
                '- Request access to your data\n'
                '- Request correction of your data\n'
                '- Request deletion of your data\n'
                '- Object to processing of your data\n'
                '- Request data portability\n'
                '- Withdraw consent at any time\n\n'
                'To exercise these rights, contact us at [contact information].\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '7. Children\'s Privacy\n'
                'The App is not intended for users under 18 years of age. We do not knowingly collect information from children under 18.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '8. Changes to This Privacy Policy\n'
                'We may update this Privacy Policy from time to time. We will notify you of any changes by:\n'
                '- Posting the new Privacy Policy in the App\n'
                '- Updating the "Last Updated" date\n'
                '- Sending a notification through the App\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '9. International Data Transfers\n'
                'If we transfer your data outside the UK/EEA, we ensure appropriate safeguards are in place through:\n'
                '- Standard contractual clauses\n'
                '- Adequacy decisions\n'
                '- Other legal mechanisms as required\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '10. Cookie Policy\n'
                'Our App does not use cookies directly. However, our service providers and app stores may use similar technologies for essential operations.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '11. Contact Us\n'
                'For any questions about this Privacy Policy or our privacy practices, please contact us at:\n\n'
                '[Company Name]\n'
                '[Address]\n'
                'Email: [email]\n'
                'Phone: [phone number]\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '12. Supervisory Authority\n'
                'You have the right to lodge a complaint with the Information Commissioner\'s Office (ICO):\n\n'
                'Information Commissioner\'s Office\n'
                'Wycliffe House\n'
                'Water Lane\n'
                'Wilmslow\n'
                'Cheshire\n'
                'SK9 5AF\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '13. Additional Information for App Store Users\n',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '13.1 Apple App Store\n'
                'Payment information for iOS users is processed according to Apple\'s Privacy Policy.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '13.2 Google Play Store\n'
                'Payment information for Android users is processed according to Google\'s Privacy Policy.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '14. Emergency Services Disclaimer\n'
                'While we maintain strict privacy practices, if we have reason to believe there is an immediate risk of serious harm, we may need to contact appropriate authorities. This would only occur in extreme circumstances where there is a clear and immediate risk to life.\n',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}