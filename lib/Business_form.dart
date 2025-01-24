import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BusinessFormPage extends StatefulWidget {
  const BusinessFormPage({super.key});

  @override
  _BusinessFormPageState createState() => _BusinessFormPageState();
}

class _BusinessFormPageState extends State<BusinessFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredAmountController =
      TextEditingController();
  final TextEditingController _equityController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  File? _fundraiserImage;
  File? _supportingDocument;
  bool _isSubmitting = false;
  String _selectedCurrency = 'USD';

  final List<String> _currencies = ['USD', 'INR', 'EUR', 'GBP'];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _fundraiserImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDocument() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _supportingDocument = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadToCloudinary(File file, String uploadPreset) async {
    try {
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/dwxakvgkk/upload");
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody)['secure_url'];
      } else {
        print(
            "Error uploading file: ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  Future<void> _submitFundraiser() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fundraiserImage == null || _supportingDocument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please upload both an image and a document.")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final imageUrl = await _uploadToCloudinary(_fundraiserImage!, "ebiza0");
      final documentUrl =
          await _uploadToCloudinary(_supportingDocument!, "ebiza0");

      if (imageUrl != null && documentUrl != null) {
        final body = {
          "title": _titleController.text,
          "description": _descriptionController.text,
          "currency": _selectedCurrency,
          "amount": int.parse(_requiredAmountController.text),
          "equity": double.parse(_equityController.text),
          "contact": _contactController.text,
          "image_url": imageUrl,
          "upi_id": _upiIdController.text,
          "document_url": documentUrl,
        };

        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/add-business'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Business created successfully!")),
          );
          _titleController.clear();
          _descriptionController.clear();
          _requiredAmountController.clear();
          _equityController.clear();

          _upiIdController.clear();
          _contactController.clear();
          setState(() {
            _fundraiserImage = null;
            _supportingDocument = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response.body}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Error uploading files. Please try again.")),
        );
      }
    } catch (e) {
      print("Error saving fundraiser: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error saving fundraiser. Please try again.")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40.0),
            const Text(
              "Business Details",
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Business Title",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    maxLength: 50,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter a title."
                        : null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Business Description",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    maxLength: 500,
                    maxLines: 4,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter a description."
                        : null,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text("Upload Image"),
                      ),
                      ElevatedButton.icon(
                        onPressed: _pickDocument,
                        icon: const Icon(Icons.attach_file),
                        label: const Text("Upload Document"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCurrency,
                          items: _currencies
                              .map((currency) => DropdownMenuItem(
                                  value: currency, child: Text(currency)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedCurrency = value!),
                          decoration:
                              const InputDecoration(labelText: "Currency"),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _requiredAmountController,
                          decoration:
                              const InputDecoration(labelText: "Amount"),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null || double.tryParse(value) == null
                                  ? "Enter a valid number."
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _equityController,
                          decoration:
                              const InputDecoration(labelText: "Equity"),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter equity."
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _contactController,
                          decoration: const InputDecoration(
                            labelText: "Contact",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null ||
                                  int.tryParse(value) == null ||
                                  value.length != 10
                              ? "Enter a valid 10-digit contact number."
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _upiIdController,
                    decoration: const InputDecoration(
                      labelText: "UPI ID",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFundraiser,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit Business"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
