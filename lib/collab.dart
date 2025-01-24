// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PsychiatristConsultationPage extends StatelessWidget {
  final List<Psychiatrist> psychiatrists = [
    Psychiatrist(
      name: "DR. RAJANI VERMA",
      qualification: "MBBS, DNB (PSYCHIATRY)",
      hospital: "JAIPRAKASH HOSPITAL & RESEARCH CENTER PVT LTD",
      price: "₹700",
      contact: "tel:9779109109",
    ),
    Psychiatrist(
      name: "DR. DEBASISH MAHANTA",
      qualification: "MBBS, MD, DNB",
      hospital: "Ispat General Hospital, Near Sector 19, Raurkela Industrialship",
      price: "₹1500",
      contact: "tel:9827381178",
    ),
    Psychiatrist(
      name: "DR. PANKAJ KUMAR NANDA",
      qualification: "MBBS, DPM",
      hospital: "Plot No-B-122, Sec-20, Rourkela Kutchery Road, Rourkela, 769042",
      price: "₹600",
      contact: "tel:7947113833",
    ),
    Psychiatrist(
      name: "Dr. Jitendriya Biswal",
      qualification: "M.D. (Psychiatry), MBBS",
      hospital: "Psychiatrist, Sexologist, Neuropsychiatrist\n17 Years Experience Overall (16 years as specialist)",
      price: "₹1000",
      contact: "tel:9779109109",
    ),
    Psychiatrist(
      name: "Dr. Bhumika Mishra",
      qualification: "MBBS, M.D. (Psychiatry)",
      hospital: "Psychiatrist\n9 Years Experience Overall (2 years as specialist)",
      price: "₹500",
      contact: "tel:9827381178",
    ),
    Psychiatrist(
      name: "Dr. S.A Idrees",
      qualification: "MBBS, DNB - Psychiatry",
      hospital: "Psychiatrist\n15 Years Experience Overall (8 years as specialist)",
      price: "₹1000",
      contact: "tel:7947113833",
    ),
  ];

  PsychiatristConsultationPage({super.key});

  void _launchDialer(String url) async {
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
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Removes the back arrow
        elevation: 0,
        title: const Text(
          "PROFESSIONAL CONSULTATION",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: psychiatrists.length,
        itemBuilder: (context, index) {
          final psychiatrist = psychiatrists[index];
          return PsychiatristCard(
            psychiatrist: psychiatrist,
            onContactPressed: () => _launchDialer(psychiatrist.contact),
          );
        },
      ),
    );
  }
}

class Psychiatrist {
  final String name;
  final String qualification;
  final String hospital;
  final String price;
  final String contact;

  Psychiatrist({
    required this.name,
    required this.qualification,
    required this.hospital,
    required this.price,
    required this.contact,
  });
}

class PsychiatristCard extends StatelessWidget {
  final Psychiatrist psychiatrist;
  final VoidCallback onContactPressed;

  const PsychiatristCard({
    super.key,
    required this.psychiatrist,
    required this.onContactPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD9FAD4), Color(0xFF92FAAA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 30, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        psychiatrist.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        psychiatrist.qualification,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  psychiatrist.price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              psychiatrist.hospital,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onContactPressed,
                child: const Text(
                  "Consult Now",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}