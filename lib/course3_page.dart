// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursesPage3 extends StatelessWidget {
  // URLs for each course
  final List<String> courseUrls = [
    'https://www.edx.org/learn/accessibility' ,
    'https://www.helenkeller.org/comprehensive-vocational-rehabilitation-program/adaptive-technology-training/',
    'https://w2.csun.edu/cod/training-programs/assistive-technology-certificate-program',
    'https://ahs.uic.edu/academics/disability-and-human-development/assistive-technology-certificate/' ,
    'https://lighthouseguild.org/support-services/assistive-technology-training/ ',
    'https://www.digitala11y.com/digital-accessibility-courses-roundup/',
  ];

  CoursesPage3({super.key});

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
            'ACCESSIBILITY',
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