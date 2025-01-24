// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursesPage5 extends StatelessWidget {
  // URLs for each course
  final List<String> courseUrls = [
    'https://www.drcpc.org/service/independent-living-skills-training/' ,
    'https://www.yai.org/resources/strive-worldwide-independent-living-skills-courses',
    'https://daylemc.org/services/skills-training/independent-living-skills-training/',
    'https://www.neils.org/the-importance-of-independent-living-skills-training/' ,
    'https://www.helenkeller.org/comprehensive-vocational-rehabilitation-program/independent-living-skills-training/ ',
    'https://www.waltonoptions.org/core-services/independent-living-skills/',
  ];

  CoursesPage5({super.key});

  // Function to open URL in browser
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 30), // Move text slightly downward
          child: Text(
            'LIVING-SKILLS',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold, // Make the text bold
              color: Colors.black, // Set the text color to black
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Make AppBar background transparent
        elevation: 0, // Remove AppBar shadow
      ),
      extendBodyBehindAppBar: true, // Extend the body behind the AppBar
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 147, 159, 237), Color.fromARGB(255, 173, 182, 253)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100.0), // Add space for the AppBar
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 panels per row
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: 6, // Total number of panels
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _launchURL(courseUrls[index]), // Open URL on tap
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF08FAEF), Color(0xFFEEFAFA)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Course ${index + 1}',
                            style: TextStyle(
                              color: Colors.grey[800], // Gray text
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}