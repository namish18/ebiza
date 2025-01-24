import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'dart:convert'; // For JSON parsing
import 'package:http/http.dart' as http; // For HTTP requests

import 'Fundraiser.dart';
import 'collab.dart';
import 'diseaselink.dart';
import 'marketplace.dart';
import 'opportunity_hub.dart';
import 'premium_page.dart';
import 'home_screen.dart'; // Import HomeScreen for Home navigation
import 'moodtracker_page.dart';
import 'profile_page.dart'; // Ensure the ProfilePage is imported

class MHPage extends StatefulWidget {
  const MHPage({super.key});

  @override
  _MHPageState createState() => _MHPageState();
}

class _MHPageState extends State<MHPage> {
  String profileImageUrl =
      'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png'; // Default image
  String userName = 'User Name'; // Default user name
  bool isLoading = true;

  // Fetch user data from the server
  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid != null) {
      const String apiUrl =
          'http://10.0.2.2:3000/get-user'; // Replace with your API URL

      try {
        final response = await http.get(Uri.parse('$apiUrl?uid=$uid'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            if (data['user'] != null) {
              userName = data['user']['fname']; // Get user name
              profileImageUrl = data['user']['image_url'] ??
                  profileImageUrl; // Get profile image URL
            }
          });
        } else {
          print('Error fetching user data: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    } else {
      print('No user ID found in SharedPreferences');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // Hide default AppBar
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                        height:
                            70), // Spacing to shift the profile section downward

                    // Profile Section
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PfilePage()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                profileImageUrl), // Display user's image
                            backgroundColor: Colors.grey, // Placeholder color
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hello!',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userName, // Display user's name
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Join Plan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // HF Image
                    Center(
                      child: Image.asset(
                        'assets/images/MH.png', // Replace with your HF image asset
                        width: 350,
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Blocks Section
                    BlockWidget(
                      imagePath: 'assets/images/Test_Image.jpeg',
                      title: 'Take a Test',
                      subtitle:
                          'Take our personalised test to get self-diagnose.',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MentalHealthTestsPage()));
                      },
                    ),
                    const SizedBox(height: 16),
                    BlockWidget(
                      imagePath: 'assets/images/Consult_Image.jpeg',
                      title: 'Consult a professional',
                      subtitle: 'Book the appointment with psychiatrist.',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PsychiatristConsultationPage()));
                      },
                    ),
                    const SizedBox(height: 16),
                    BlockWidget(
                      imagePath: 'assets/images/Mood_Tracker.jpeg',
                      title: 'Mood Tracker',
                      subtitle: 'Mark your daily mood and get results.',
                      onTap: () {
                        // Navigate to HomeTracker for Mood Tracker
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MTPage()));
                      },
                    ),
                  ],
                ),
              ),
            ),
      // Bottom Navigation Bar with 5 Icons
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF191031),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/home.png'),
              color: Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/wheelchair.png')),
            label: 'Accessibility',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/money.png')),
            label: 'Finance',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/mental-health.png')),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/graduation.png')),
            label: 'Opportunities',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MarketplacePage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FundraiserPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MHPage()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Oppt()),
              );
              break;
          }
        },
      ),
    );
  }
}

// Reusable BlockWidget
class BlockWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const BlockWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150, // Fixed height for all boxes
        width: double.infinity, // Full width of the screen
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: Image.asset(
                imagePath,
                width: 120, // Fixed width for image
                height: 150, // Match container height
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFAEF1FA),
                      Color(0xFF67ECFA)
                    ], // Gradient colors
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15, // Font size for title
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text in black
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10, // Font size for subtitle
                        color: Colors.black87, // Slightly lighter black
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
