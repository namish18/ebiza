import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? name;
  String? email;
  String? imageUrl;
  String? defaultImageUrl =
      'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    const String apiUrl = "http://10.0.2.2:3000/get-user";

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('uid');

      if (userId == null) {
        print("User ID is null. Ensure the user is logged in.");
        return;
      }

      final response = await http.get(Uri.parse('$apiUrl?uid=$userId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['user'] != null) {
          setState(() {
            name = "${data['user']['fname']} ${data['user']['lname']}";
            email = data['user']['email'];
            imageUrl = data['user']['image_url'] ?? defaultImageUrl;
          });
        }
      } else {
        print("Failed to fetch user data: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 100.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : const AssetImage('assets/profile_placeholder.png')
                        as ImageProvider,
              ),
              const SizedBox(height: 16),
              Text(
                name ?? 'Loading...',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                email ?? 'Loading...',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildStatCard(
                context,
                title: 'Total Donated',
                amount: '₹89000.70',
                backgroundImage: 'assets/images/Donation.jpg',
                onTap: () {},
                titleColor: Colors.white,
                amountColor: Colors.white,
                isTransparent: false,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                context,
                title: 'Total Fundraised',
                amount: '₹420000.30',
                backgroundImage: 'assets/images/Fund.webp',
                onTap: () {},
                titleColor: Colors.black,
                amountColor: Colors.black,
                isTransparent: false,
              ),
              const SizedBox(height: 16),
              _buildFundraiserCard(
                context,
                title: 'My Fundraisers',
                onTap: () {
                  _showFundraiserPopup(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String amount,
    required String backgroundImage,
    required VoidCallback onTap,
    required Color titleColor,
    required Color amountColor,
    required bool isTransparent,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isTransparent ? Colors.white.withOpacity(0.8) : null,
            image: isTransparent
                ? null
                : DecorationImage(
                    image: AssetImage(backgroundImage),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFundraiserCard(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  void _showFundraiserPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('My Fundraiser'),
          content: const Text(
              'You have created one fundraiser. Tap to view details.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FundraiserDetailsPage()),
                );
              },
              child: const Text('View'),
            ),
          ],
        );
      },
    );
  }
}

class FundraiserDetailsPage extends StatelessWidget {
  const FundraiserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fundraiser Details'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          'Details of the fundraiser will be displayed here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
