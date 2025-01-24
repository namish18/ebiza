// ignore_for_file: library_private_types_in_public_api, unused_import

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class FundraiserFormPage extends StatefulWidget {
  const FundraiserFormPage({super.key});

  @override
  _FundraiserFormPageState createState() => _FundraiserFormPageState();
}

class _FundraiserFormPageState extends State<FundraiserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredAmountController =
      TextEditingController();
  final TextEditingController _timeDurationController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  File? _fundraiserImage;
  File? _supportingDocument;
  bool _isSubmitting = false;
  String _selectedCurrency = 'USD';
  String _selectedDurationMode = 'Days';

  final List<String> _currencies = ['USD', 'INR', 'EUR', 'GBP'];
  final List<String> _durationModes = ['Days', 'Weeks', 'Months'];

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

  Future<String?> _uploadFileToCloudinary(File file) async {
    const cloudinaryUrl = "https://api.cloudinary.com/v1_1/dwxakvgkk/upload";
    const presetName = "ebiza0"; // Replace with your upload preset

    try {
      final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = presetName
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(
            responseBody)['secure_url']; // Cloudinary returns a secure URL
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
      // Upload image to Cloudinary
      final imageUrl = await _uploadFileToCloudinary(_fundraiserImage!);

      // Upload document to Cloudinary
      final documentUrl = await _uploadFileToCloudinary(_supportingDocument!);

      if (imageUrl != null && documentUrl != null) {
        // Prepare request body
        final fundraiserData = {
          "title": _titleController.text.trim(),
          "currency": _selectedCurrency,
          "amount": double.parse(_requiredAmountController.text.trim()),
          "raised": 0, // Initial raised amount is 0
          "description": _descriptionController.text.trim(),
          "duration": int.parse(_timeDurationController.text.trim()),
          "duration_mode": _selectedDurationMode,
          "upi_id": _upiIdController.text.trim(),
          "image": imageUrl,
          "doc": documentUrl,
        };

        // Send data to backend
        const String apiUrl = "http://10.0.2.2:3000/add-fundraiser";
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode(fundraiserData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fundraiser created successfully!")),
          );

          // Clear form
          _titleController.clear();
          _descriptionController.clear();
          _requiredAmountController.clear();
          _timeDurationController.clear();
          _upiIdController.clear();
          setState(() {
            _fundraiserImage = null;
            _supportingDocument = null;
          });
        } else {
          print("Error adding fundraiser: ${response.body}");
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
            const SizedBox(height: 40.0), // Additional space at the top
            const Text(
              "Fundraiser Details",
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
                      labelText: "Fundraiser Title",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    maxLength: 255,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter a title."
                        : null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Fundraiser Description",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    maxLength: 800,
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
                          controller: _timeDurationController,
                          decoration:
                              const InputDecoration(labelText: "Duration"),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter duration."
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedDurationMode,
                          items: _durationModes
                              .map((mode) => DropdownMenuItem(
                                  value: mode, child: Text(mode)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedDurationMode = value!),
                          decoration: const InputDecoration(labelText: "Mode"),
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
                    validator: (value) => value == null ||
                            !RegExp(r"^[\w.-]+@[\w.-]+$").hasMatch(value)
                        ? "Enter a valid UPI ID."
                        : null,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFundraiser,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit Fundraiser"),
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
