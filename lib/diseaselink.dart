import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MentalHealthTestsPage extends StatelessWidget {
  final List<Map<String, String>> tests = [
    {
      'title': 'Depression Test',
      'url': 'https://screening.mhanational.org/screening-tools/depression/?ref'
    },
    {
      'title': 'Postpartum Depression Test',
      'url': 'https://screening.mhanational.org/screening-tools/postpartum-depression/?ref'
    },
    {
      'title': 'Anxiety Test',
      'url': 'https://screening.mhanational.org/screening-tools/anxiety/?ref'
    },
    {
      'title': 'ADHD Test',
      'url': 'https://screening.mhanational.org/screening-tools/adhd/?ref'
    },
    {
      'title': 'Bipolar Test',
      'url': 'https://screening.mhanational.org/screening-tools/bipolar/?ref'
    },
    {
      'title': 'Psychosis & Schizophrenia Test',
      'url': 'https://screening.mhanational.org/screening-tools/psychosis-schizophrenia/?ref'
    },
    {
      'title': 'PTSD Test',
      'url': 'https://screening.mhanational.org/screening-tools/ptsd/?ref'
    },
    {
      'title': 'Eating Disorder Test',
      'url': 'https://screening.mhanational.org/screening-tools/eating-disorder/?ref'
    },
    {
      'title': 'Addiction Test',
      'url': 'https://screening.mhanational.org/screening-tools/addiction/?ref'
    },
    {
      'title': 'Parent Test: Your Child’s Mental Health',
      'url': 'https://screening.mhanational.org/screening-tools/parent/?ref'
    },
  ];

  MentalHealthTestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Removes the back arrow
        elevation: 0,
        title: const Center(
          child: Text(
            'MENTAL HEALTH TESTS',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tests.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA2FAA1), Color(0xFF4AFAA3)],
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    final Uri url = Uri.parse(tests[index]['url']!);
                    try {
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        throw 'Could not launch $url';
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Center(
                    child: Text(
                      tests[index]['title']!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEFA7B), Color(0xFFFAE555)],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Take a Mental Health Test',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}