import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloperPage extends StatelessWidget {
  const AboutDeveloperPage({super.key});

  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Tidak dapat membuka URL: $url';
    }
  }

  void _sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    final String emailLaunchUri = uri.toString();
    // ignore: deprecated_member_use
    if (await canLaunch(emailLaunchUri)) {
      // ignore: deprecated_member_use
      await launch(emailLaunchUri);
    } else {
      throw 'Tidak dapat membuka Email: $email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Developer',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: [
          _buildDeveloperCard(
            name: 'Nazri Arwadi',
            role: 'Flutter Developer',
            imagePath: 'assets/images/profil_wadi.png',
            instagramUrl: 'https://instagram.com/nz.wadi?igshid=MzNlNGNkZWQ4Mg==',
            email: 'nazriarwadi@example.com',
          ),
          const SizedBox(height: 24.0),
          _buildDeveloperCard(
            name: 'Nani Berliyani',
            role: 'UI/UX Designer',
            imagePath: 'assets/images/profil_nani.png',
            instagramUrl: 'https://instagram.com/zahra.awaa__?igshid=MzNlNGNkZWQ4Mg==',
            email: 'naniberliyani@example.com',
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard({
    required String name,
    required String role,
    required String imagePath,
    required String instagramUrl,
    required String email,
  }) {

    return Card(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Colors.black, width: 3)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(imagePath),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              role,
              style: const TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 109, 108, 108),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _launchURL(instagramUrl);
                  },
                  icon: Image.asset(
                    'assets/icons/icon_instagram.png',
                    width: 80.0,
                    height: 80.0,
                  ),
                ),
                const SizedBox(width: 14),
                IconButton(
                  onPressed: () {
                    _sendEmail(email);
                  },
                  icon: Image.asset(
                    'assets/icons/Email.png',
                    width: 80.0,
                    height: 80.0,
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
