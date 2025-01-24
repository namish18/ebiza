import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests
import 'premium_page.dart';

class MerchandisePage extends StatefulWidget {
  const MerchandisePage({super.key});

  @override
  _MerchandisePageState createState() => _MerchandisePageState();
}

class _MerchandisePageState extends State<MerchandisePage> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchMerchandise();
  }

  Future<void> fetchMerchandise() async {
    const String apiUrl = 'http://10.0.2.2:3000/view-merchandise';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          products = data.map((item) {
            return {
              'name': item['name'],
              'image': item['image_url'],
            };
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load merchandise.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching merchandise.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(255, 255, 37, 114)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80), // Space added at the top
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductTile(
                            name: product['name'],
                            price: (index + 1) * 1000,
                            imageUrl: product['image'], // Pass image URL from API
                            onAddToCart: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product['name']} added to cart')),
                              );
                            },
                            onViewProduct: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PPage()),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String name;
  final int price;
  final String imageUrl;
  final VoidCallback onAddToCart;
  final VoidCallback onViewProduct;

  const ProductTile({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.onAddToCart,
    required this.onViewProduct,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewProduct,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color.fromARGB(255, 233, 60, 60)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    imageUrl, // Use network image for API data
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.broken_image));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.diamond, color: Colors.blue),
                    onPressed: onAddToCart,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
