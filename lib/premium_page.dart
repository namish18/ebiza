import 'package:flutter/material.dart';


class PPage extends StatelessWidget {
  const PPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'PREMIUM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: PageController(viewportFraction: 0.8),
        physics: const BouncingScrollPhysics(),
        pageSnapping: true,
        onPageChanged: (index) {},
        children: [
          buildCard(
            context,
            title: 'Month',
            price: '₹1299',
            description: [
              'Premium tools and detailed data analysis',
              'Specialized technical courses',
              'Zero Platform Fees',
              'Enjoy exclusive branded merchandise',
            ],
          ),
          buildCard(
            context,
            title: 'Quarter',
            price: '₹999',
            isPopular: true,
            description: [
              'Premium tools and detailed data analysis',
              'Specialized technical courses',
              'Zero Platform Fees',
              'Enjoy exclusive branded merchandise',
            ],
          ),
          buildCard(
            context,
            title: 'Annual',
            price: '₹699',
            description: [
              'Premium tools and detailed data analysis',
              'Specialized technical courses',
              'Zero Platform Fees',
              'Enjoy exclusive branded merchandise',
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context,
      {required String title,
      required String price,
      required List<String> description,
      bool isPopular = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: isPopular
              ? Border.all(color: Colors.green, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (isPopular) const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$price/mo',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...description.map(
              (text) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You selected $title plan'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Buy now',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}