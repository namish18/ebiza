// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CollaborationPage(),
  ));
}

class CollaborationPage extends StatelessWidget {
  final List<Map<String, String>> collaborators = [
    {
      'name': 'Ford Foundation',
      'logo': 'assets/images/Ford_Foundation.webp',
      'url': 'https://www.fordfoundation.org/',
    },
    {
      'name': 'Tata Trusts',
      'logo': 'assets/images/tata_trusts.png',
      'url': 'https://www.tatatrusts.org/',
    },
    {
      'name': 'Infosys Foundation',
      'logo': 'assets/images/infosys_foundation.png',
      'url': 'https://www.infosys.org/infosys-foundation.html',
    },
    {
      'name': 'Accenture Inclusive Work',
      'logo': 'assets/images/accenture_inclusive_work.png',
      'url': 'https://www.accenture.com/in-en/about/corporate-citizenship/inclusive-future-work-call-action',
    },
    {
      'name': 'World Health Organization',
      'logo': 'assets/images/world_health_organization.png',
      'url': 'https://www.who.int/health-topics/disability#tab=tab_1',
    },
  ];

  CollaborationPage({super.key});

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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'COLLABORATIONS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromARGB(255, 255, 255, 224)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8, // Adjust the height-to-width ratio
          ),
          itemCount: collaborators.length,
          itemBuilder: (context, index) {
            return _buildCollaboratorCard(collaborators[index]);
          },
        ),
      ),
    );
  }

  Widget _buildCollaboratorCard(Map<String, String> collaborator) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color.fromARGB(255, 135, 206, 250)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(12.0),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: AssetImage(collaborator['logo']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            collaborator['name']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: () {
              _launchURL(collaborator['url']!);
            },
            child: const Text(
              'Visit Now',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}