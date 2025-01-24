// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class FundraiserDetailApp extends StatelessWidget {
  final int fundraiserId;

  const FundraiserDetailApp({super.key, required this.fundraiserId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FundraiserDetailPage(fundraiserId: fundraiserId),
    );
  }
}

class FundraiserDetailPage extends StatefulWidget {
  final int fundraiserId;

  const FundraiserDetailPage({super.key, required this.fundraiserId});

  @override
  _FundraiserDetailPageState createState() => _FundraiserDetailPageState();
}

class _FundraiserDetailPageState extends State<FundraiserDetailPage> {
  Map<String, dynamic>? fundraiser;
  List<dynamic> contributors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFundraiserDetails();
  }

  Future<void> fetchFundraiserDetails() async {
    final url = Uri.parse(
        'http://10.0.2.2:3000/view-fundraiser?fid=${widget.fundraiserId}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fundraiser = data[0];

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load fundraiser details');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : fundraiser == null
              ? const Center(child: Text('Fundraiser not found'))
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 151, 193, 255)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 100.0,
                          left: 10.0,
                          right: 10.0), // Added top padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fundraiser Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              fundraiser!['image_url'],
                              height: 200.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Title
                          Text(
                            fundraiser!['title'],
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Description
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            fundraiser!['description'],
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Contributors
                          Text(
                            "${contributors.length} Contributors",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: contributors.length,
                            itemBuilder: (context, index) {
                              final contributor = contributors[index];
                              return ListTile(
                                leading: const Icon(Icons.account_circle,
                                    size: 40.0),
                                title: Text(contributor['name'] ?? 'Anonymous'),
                                subtitle: Text(contributor['time'] ?? ''),
                                trailing: Text(
                                  "₹${(contributor['amount'] ?? 0).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),

      // Share and Pay Buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Share.share(
                  'Check out this fundraiser: ${fundraiser!['title']}\nHelp by contributing here!',
                );
              },
              icon: const Icon(Icons.share, color: Colors.white),
              label: const Text(
                "Share Campaign",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                // Integrate Razorpay Payment here
              },
              icon: const Icon(Icons.payment, color: Colors.white),
              label: const Text(
                "Pay",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
