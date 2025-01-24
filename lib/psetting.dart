import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PSetting extends StatefulWidget {
  const PSetting({super.key});

  @override
  State<PSetting> createState() => _PSettingState();
}

class _PSettingState extends State<PSetting> {
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
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditPage(),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      leading: CircleAvatar(
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl!)
                            : const AssetImage('assets/profile_placeholder.png')
                                as ImageProvider,
                      ),
                      title: Text(name ?? 'Loading...'),
                      subtitle: Text(email ?? 'Loading...'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  const Divider(),
                  SettingItem(
                    icon: Icons.notifications,
                    title: 'Notification',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                  SettingItem(
                    icon: Icons.language,
                    title: 'Language',
                    trailingText: 'English',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LanguagePage(),
                        ),
                      );
                    },
                  ),
                  SettingItem(
                    icon: Icons.privacy_tip,
                    title: 'Privacy',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPage(),
                        ),
                      );
                    },
                  ),
                  SettingItem(
                    icon: Icons.help_center,
                    title: 'Help Center',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpCenterPage(),
                        ),
                      );
                    },
                  ),
                  SettingItem(
                    icon: Icons.info,
                    title: 'About Us',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUsPage(),
                        ),
                      );
                    },
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

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: trailingText != null
          ? Text(trailingText!, style: const TextStyle(color: Colors.grey))
          : const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String? finame;
  String? laname;
  String? uemail;
  String? uimageUrl;
  String profileImageUrl =
      'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png';
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;
  String? _imageUrl;
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    const cloudName = "dwxakvgkk";
    const uploadPreset = "ebiza0";
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData['secure_url'];
    } else {
      print('Error uploading image to Cloudinary');
      return null;
    }
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     final cloudinary = CloudinaryContext.instance;
  //     final response = await cloudinary.uploadFile(
  //       CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.image),
  //     );
  //     setState(() {
  //       _imageUrl = response.secureUrl;
  //     });
  //   }
  // }
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
            finame = data['user']['fname'];
            laname = data['user']['lname'];
            uemail = data['user']['email'];
            uimageUrl = data['user']['image_url'] ?? profileImageUrl;
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

  Future<void> _saveData() async {
    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImageToCloudinary(_image!);
    }
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    final fname =
        _fnameController.text.isNotEmpty ? _fnameController.text : finame;
    final lname =
        _lnameController.text.isNotEmpty ? _lnameController.text : laname;
    final email =
        _emailController.text.isNotEmpty ? _emailController.text : uemail;

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/update-user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'uid': uid,
        'fname': fname ?? finame,
        'lname': lname ?? laname,
        'email': email ?? uemail,
        'imageUrl': imageUrl ?? uimageUrl,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageUrl != null
                    ? NetworkImage(_imageUrl!)
                    : const AssetImage('assets/profile_placeholder.png')
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fnameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveData,
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: SwitchListTile(
          title: const Text('Enable Notifications'),
          value: true,
          onChanged: (value) {
            // Logic for toggling notifications
          },
        ),
      ),
    );
  }
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: ListTile(
          title: const Text('English'),
          trailing: const Icon(Icons.check, color: Colors.blue),
          onTap: () {},
        ),
      ),
    );
  }
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Text(
            'This Privacy Policy explains how Ebiza collects, uses, and protects your personal data. It applies to all services offered on Ebiza, including our marketplace, fundraising, and more...',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            ExpansionTile(
              title: Text('How to use the app?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Here is how you use the app...'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to reset my password?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('To reset your password...'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: Text(
          'At Yantram.dev, we are a team of innovators building impactful digital solutions like Ebiza, an all-in-one platform for empowering individuals and fostering inclusion.',
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
