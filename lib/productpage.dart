import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const PDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(255, 147, 166, 252)
            ], // White to light sky blue
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 100.0, left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Center(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: product['image_url'].isNotEmpty
                              ? Image.network(
                                  product['image_url'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Image.asset(
                                  'assets/images/product.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Product Title
                      Text(
                        product['name'] ??
                            'Unknown Product', // Default name if null
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Product Price
                      Text(
                        "₹${product['price'] ?? '0.00'}", // Default price if null
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Product Review
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 20),
                          Text(
                            product['rating'].toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Text(
                            "(20 Reviews)",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Product Description
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product['description'] ??
                            'No description available.', // Default description if null
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Proceeding to checkout...")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 38, 38, 221),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(
                          color: Colors.white, // Sets the text color to white
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      const String apiUrl = "http://10.0.2.2:3000/add-to-cart";
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? userId = prefs.getString('uid');

                      final String uid =
                          userId.toString(); // Replace with actual user ID
                      final int pid =
                          product['pid']; // Replace with actual product ID
                      const int quantity = 1;

                      try {
                        final response = await http.post(
                          Uri.parse(apiUrl),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'uid': int.parse(uid),
                            'pid': pid,
                            'quantity': quantity,
                          }),
                        );

                        if (response.statusCode == 201) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to cart")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Failed to add to cart")),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Icon(Icons.shopping_cart),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
