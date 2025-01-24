import 'package:app_hk/Fundraiser.dart';
import 'package:flutter/material.dart';
import 'collab_page.dart';
import 'courses_page.dart';
import 'marketplace.dart';
import 'buz_inv.dart';
import 'home_screen.dart';
import 'MentalHealth_page.dart';

class Oppt extends StatelessWidget {
  const Oppt({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100.0), // Adjusted spacing at the top
            const Text(
              'OPPORTUNITY HUB+',
              style: TextStyle(
                color: Colors.black, // Ensure the text is visible
                fontSize: 28.0, // Slightly larger font size for prominence
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 150.0), // Adjust spacing below the title
            buildOpportunityCard(
              context,
              title: 'Business Investments',
              description: 'Empower your ventures with smart strategies.',
              icon: const ImageIcon(AssetImage('assets/images/briefcase.png'), size: 40.0),
              gradientColors: [const Color(0xFFFDD26A), const Color(0xFFA77200)],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InvestmentPage()),
                );
              },
            ),
            const SizedBox(height: 16.0),
            buildOpportunityCard(
              context,
              title: 'Courses',
              description: 'Learn, grow, and unlock your potential.',
              icon: const ImageIcon(AssetImage('assets/images/online-learning.png'), size: 40.0),
              gradientColors: [const Color(0xFFFF0022), const Color(0xFFF37A00)],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoursePage()),
                );
              },
            ),
            const SizedBox(height: 16.0),
            buildOpportunityCard(
              context,
              title: 'Collaborations',
              description: 'Join forces to create impactful opportunities.',
              icon: Image.asset(
                'assets/images/deal.png',
                height: 40.0,
                width: 40.0,
                fit: BoxFit.contain,
              ),
              gradientColors: [const Color(0xFF3B82F6), const Color.fromARGB(255, 171, 188, 227)],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CollaborationPage()),
                );
              },
            ),
          ],
        ),
      ),
    ),
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
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MarketplacePage()),
          );
        }
        if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FundraiserPage()),
          );
        }
        if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MHPage()),
          );
        }
        if (index == 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Oppt()),
          );
        }
      },
    ),
  );
}

  Widget buildOpportunityCard(
    BuildContext context, {
    required String title,
    required String description,
    required Widget icon,
    required List<Color> gradientColors,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.3),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}