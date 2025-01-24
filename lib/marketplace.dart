import 'package:flutter/material.dart';
import 'Fundraiser.dart';
import 'MentalHealth_page.dart';
import 'cart.dart';
import 'home_screen.dart';
import 'opportunity_hub.dart';
import 'productlist.dart';
import 'productpage.dart';
import 'profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String firstName = '';
  String lastName = '';
  String profileImageUrl =
      'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png';
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

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
            firstName = data['user']['fname'];
            lastName = data['user']['lname'];
            profileImageUrl = data['user']['image_url'] ?? profileImageUrl;
          });
        }
      } else {
        print("Failed to fetch user data: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching user data: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PfilePage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(profileImageUrl),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello!",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                            Text(
                              "$firstName $lastName",
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, size: 25),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search here",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              SectionHeader(
                title: "Search Results",
                onTap: () {},
              ),
              ProductList(
                searchTerm: searchController.text,
                limit: null,
              ),
              const SizedBox(height: 16),
              // Banner Section
              SizedBox(
                height: 150,
                child: PageView(
                  children: const [
                    BannerWidget(
                      text: "Get Winter Discount\n20% Off\nFor Children",
                      imageUrl: 'assets/images/gift.png',
                      backgroundColor: Color.fromARGB(255, 77, 11, 142),
                      imagePadding: EdgeInsets.only(left: 50),
                    ),
                    BannerWidget(
                      text: "Exclusive Offers\nUp to 50% Off",
                      imageUrl: 'assets/images/gift.png',
                      backgroundColor: Color.fromARGB(255, 158, 14, 55),
                      imagePadding: EdgeInsets.only(left: 50),
                    ),
                  ],
                ),
              ),
              SectionHeader(
                title: "Featured Products",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductPage()),
                  );
                },
              ),
              const ProductList(limit: 5),
              const SizedBox(height: 16),
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
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MarketplacePage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FundraiserPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MHPage()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Oppt()),
              );
              break;
          }
        },
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  final String text;
  final String imageUrl;
  final Color backgroundColor;
  final EdgeInsets imagePadding;

  const BannerWidget({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.backgroundColor,
    this.imagePadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          // Text Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Image on the right
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/images/gift.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  final String searchTerm;
  final int? limit;

  const ProductList({
    super.key,
    this.searchTerm = '',
    this.limit,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/view-products'));
    if (response.statusCode == 200) {
      final List<dynamic> fetchedProducts = json.decode(response.body);
      setState(() {
        products = fetchedProducts.cast<Map<String, dynamic>>().toList();
        filterProducts();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void filterProducts() {
    final searchTerm = widget.searchTerm.toLowerCase();
    setState(() {
      filteredProducts = products
          .where(
              (product) => product['name'].toLowerCase().contains(searchTerm))
          .toList();
      if (widget.limit != null) {
        filteredProducts = filteredProducts.take(widget.limit!).toList();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ProductList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchTerm != widget.searchTerm) {
      filterProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filteredProducts
            .map((product) => ProductCard(product: product))
            .toList(),
      ),
    );
  }
}

// class ProductList extends StatefulWidget {
//   const ProductList({super.key});

//   @override
//   State<ProductList> createState() => _ProductListState();
// }

// class _ProductListState extends State<ProductList> {
//   List<Map<String, dynamic>> products = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     final response = await http.get(Uri.parse('http://10.0.2.2:3000/view-products'));
//     if (response.statusCode == 200) {
//       final List<dynamic> fetchedProducts = json.decode(response.body);
//       setState(() {
//         products = fetchedProducts.take(5).cast<Map<String, dynamic>>().toList();
//       });
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: products.map((product) => ProductCard(product: product)).toList(),
//       ),
//     );
//   }
// }

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(product['image_url']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['name'],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "\u20B9${product['price']}",
              style: const TextStyle(fontSize: 14, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

// class ProductDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> product;
//   const ProductDetailsPage({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product['name']),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(product['image_url']),
//             const SizedBox(height: 16),
//             Text(
//               product['name'],
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             Text("\u20B9${product['price']}",
//                 style: const TextStyle(fontSize: 20, color: Colors.green)),
//             const SizedBox(height: 16),
//             Text(product['description']),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Text(
              "See All",
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
