// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Funddetail.dart';
import 'fr_form.dart';
import 'home_screen.dart';
import 'marketplace.dart';
import 'MentalHealth_page.dart';
import 'opportunity_hub.dart';

class FundraiserPage extends StatefulWidget {
  const FundraiserPage({super.key});

  @override
  _FundraiserPageState createState() => _FundraiserPageState();
}

class _FundraiserPageState extends State<FundraiserPage> {
  List<dynamic> fundraisers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFundraisers();
  }

  Future<void> fetchFundraisers() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/view-fundraiser'));

      if (response.statusCode == 200) {
        setState(() {
          fundraisers = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load fundraisers');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching fundraisers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Center(
          child: Text(
            "FUNDRAISER",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0E768D), Color(0xFF000000)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FundraiserFormPage()),
                      );
                    },
                    child: const Text(
                      "Create Your Fundraiser",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Some Fundraisers to contribute",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: fundraisers.length,
                      itemBuilder: (context, index) {
                        final fundraiser = fundraisers[index];
                        final progress =
                            fundraiser['raised'] / fundraiser['amount'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FundraiserDetailApp(
                                    fundraiserId: fundraiser['fid']),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFAEF1FA), Color(0xFF67ECFA)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                  child: Image.network(
                                    fundraiser['image_url'],
                                    height: 200.0,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    fundraiser['title'],
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    color: Colors.pink,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "₹${fundraiser['raised'].toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "₹${fundraiser['amount'].toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
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
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MarketplacePage()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FundraiserPage()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MHPage()),
            );
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Oppt()),
            );
          }
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
      ),
    );
  }
}

class MentalHealthPage extends StatelessWidget {
  const MentalHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mental Health"),
      ),
      body: const Center(
        child: Text("Welcome to the Mental Health Page"),
      ),
    );
  }
}

class Opp extends StatelessWidget {
  const Opp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Opportunities"),
      ),
      body: const Center(
        child: Text("Welcome to the Opportunities Page"),
      ),
    );
  }
}
