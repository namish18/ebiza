import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  int get subtotal => products.fold(
      0, (sum, item) => sum + (item['price'] * item['quantity'] as int));
  int get discount => (subtotal * 10) ~/ 100; // 10% discount
  int get deliveryCharges => 64;
  int get total => subtotal - discount + deliveryCharges;

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    const String apiUrl = "http://10.0.2.2:3000/view-cart";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('uid');
    final String uid = userId.toString(); // Replace with the actual user ID.

    try {
      final response = await http.get(Uri.parse("$apiUrl?uid=$uid"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          products =
              List<Map<String, dynamic>>.from(data['cartItems'].map((item) => {
                    'name': item['name'],
                    'price': item['total'], // Using `cart.total` as the price
                    'quantity': item['quantity'],
                    'image': item['image_url'],
                    'cartid': item['cartid']
                  }));

          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load cart data: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void incrementQuantity(int index) {
    setState(() {
      products[index]['quantity']++;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (products[index]['quantity'] > 1) {
        products[index]['quantity']--;
      }
    });
  }

  void removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 50.0), // Added top padding
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.network(product['image'],
                                width: 50, height: 50, fit: BoxFit.cover),
                            title: Text(product['name']),
                            subtitle: Text("₹${product['price']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      debugPrint(
                                          "Decrement button pressed for index: $index");
                                      decrementQuantity(index);
                                    }),
                                Text("${product['quantity']}"),
                                IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      debugPrint(
                                          "Increment button pressed for index: $index");
                                      incrementQuantity(index);
                                    }),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => removeProduct(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order Summary",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Items"),
                          Text("${products.length}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal"),
                          Text("₹$subtotal"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Discount"),
                          Text("-₹$discount"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Delivery Charges"),
                          Text("₹$deliveryCharges"),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("₹$total",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaymentPage(total: total)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 38, 41, 212),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "Check Out",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final int total;

  const PaymentPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color.fromARGB(255, 38, 32, 232),
      ),
      body: Center(
        child: Text(
          "Total Amount to Pay: ₹$total",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
