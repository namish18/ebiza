import 'dart:convert';
import 'package:app_hk/collab_page.dart';
import 'package:app_hk/courses_page.dart';
import 'package:app_hk/merchandise.dart';
import 'package:app_hk/premium_page.dart';

import 'package:app_hk/psetting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard.dart';

class PfilePage extends StatefulWidget {
  const PfilePage({super.key});

  @override
  State<PfilePage> createState() => _PfilePageState();
}

class _PfilePageState extends State<PfilePage> {
  String? name;
  String? email;
  String? imageUrl;
  String profileImageUrl =
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
        print("User ID is null. Please make sure the user is logged in.");
        return;
      }

      final response = await http.get(Uri.parse('$apiUrl?uid=$userId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['user'] != null) {
          setState(() {
            name = "${data['user']['fname']} ${data['user']['lname']}";
            email = data['user']['email'];
            imageUrl = data['user']['image_url'] ?? profileImageUrl;
          });
        }
      } else {
        print("Failed to fetch user data: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching user data: $error");
    } finally {
      setState((bool isLoading) {
        isLoading = false;
      } as VoidCallback);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 150), // Extra space above profile
            CircleAvatar(
              radius: 40,
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : const AssetImage('assets/avatar.png') as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              name ?? 'Loading...',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              email ?? 'Loading...',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  buildListTile(context, Icons.dashboard, 'User Dashboard',
                      const Dashboard()),
                  buildListTile(
                      context, Icons.settings, 'Setting', const PSetting()),
                  buildListTile(context, Icons.school, 'Courses', CoursePage()),
                  buildListTile(context, Icons.group, 'Collaboration',
                      CollaborationPage()),
                  buildListTile(
                      context, Icons.diamond, 'Premium', const PPage()),
                  buildListTile(context, Icons.shopping_bag, 'Merchandise',
                      const MerchandisePage()),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle sign out action
                Navigator.pushReplacementNamed(context, '/landing');
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(
      BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
