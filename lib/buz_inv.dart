import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'Business_form.dart';


class InvestmentPage extends StatefulWidget {
  const InvestmentPage({super.key});

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  List<Map<String, dynamic>> _businesses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBusinesses();
  }

  Future<void> fetchBusinesses() async {
    const String apiUrl = "http://10.0.2.2:3000/view-business";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _businesses = data.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        throw Exception(
            "Failed to load data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SOME BUSINESS TO INVEST",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BusinessFormPage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ask Investments for Your Business",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _businesses.length,
                    itemBuilder: (context, index) {
                      final business = _businesses[index];
                      return InvestmentCard(
                        title: business['title'],
                        description: business['description'],
                        totalAsk: business['amount'].toString(),
                        equity: "${business['equity']}% Equity",
                        contactNumber: business['contact'],
                        imageUrl: business['image_url'], // Pass image URL
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class InvestmentCard extends StatelessWidget {
  final String title;
  
  final String description;
  final String totalAsk;
  final String equity;
  final String contactNumber;
  final String?
      imageUrl; // Make it nullable in case the API doesn't return a URL

  const InvestmentCard({
    super.key,
    required this.title,
    required this.description,
    required this.totalAsk,
    required this.equity,
    required this.contactNumber,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255), // White
                Color.fromARGB(255, 106, 146, 255), // Light Green
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      height: 120,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 120);
                      },
                    )
                  : const Icon(Icons.broken_image, size: 120),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total Ask: ₹$totalAsk",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      equity,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return MakeDealPopup(totalAsk: totalAsk);
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: const Text("Make a Deal"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 40, 136, 41),
                          ),
                          onPressed: () async {
                            final Uri phoneUri =
                                Uri(scheme: 'tel', path: contactNumber);
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Cannot open dialer.")),
                              );
                            }
                          },
                          child: const Text(
                            "Contact",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MakeDealPopup extends StatelessWidget {
  final String totalAsk;

  const MakeDealPopup({super.key, required this.totalAsk});

  @override
  Widget build(BuildContext context) {
    final TextEditingController offerAmountController = TextEditingController();
    final TextEditingController offerAskController = TextEditingController();

    return AlertDialog(
      title: const Text("Make a Deal"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: offerAmountController,
            decoration: const InputDecoration(labelText: "Offer Amount"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: offerAskController,
            decoration: const InputDecoration(labelText: "Offer Ask"),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle deal submission logic here
            Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}

class AddInvestmentPage extends StatelessWidget {
  const AddInvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Investment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text("Add Investment Page Content"),
      ),
    );
  }
}

class IndividualPage extends StatelessWidget {
  const IndividualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Individual Business Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text("Individual Business Details Page Content"),
      ),
    );
  }
}
