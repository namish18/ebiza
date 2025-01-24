import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this dependency to pubspec.yaml.

class SuccessStoriesPage extends StatelessWidget {
  final List<Map<String, String>> stories = [
    {
      'name': 'Ravi Sharma',
      'quote': '“This app changed my life, giving me confidence like never before.”',
      'image': 'assets/images/ravi.jpeg',
      'description':
          'Ravi Sharma, a visually impaired individual, used our app to connect with experts who helped him find employment and live independently. Today, he runs his own small business, inspiring others like him.'
    },
    {
      'name': 'Sunita Verma',
      'quote': '“With this app, I found guidance to lead a fulfilling life.”',
      'image': 'assets/images/sunita.jpeg',
      'description':
          'Sunita Verma, a wheelchair user, discovered resources to improve accessibility in her workplace. She is now a successful project manager and advocates for workplace inclusion.'
    },
    {
      'name': 'Arjun Kumar',
      'quote': '“The support I received was a turning point in my life.”',
      'image': 'assets/images/arjuna.jpeg',
      'description':
          'Arjun Kumar, who has hearing impairments, benefited from the app’s professional consultations. He now works as a graphic designer and actively mentors other disabled individuals.'
    },
    {
      'name': 'Priya Nair',
      'quote': '“I am now more confident to face life’s challenges.”',
      'image': 'assets/images/sunitaa.jpeg',
      'description':
          'Priya Nair, who has a speech disability, gained the confidence to pursue higher education with the app’s support. She is currently completing her PhD and aims to be a role model for others.'
    },
    {
      'name': 'Vikas Mishra',
      'quote': '“This app gave me the tools to rebuild my future.”',
      'image': 'assets/images/vikas.jpeg',
      'description':
          'Vikas Mishra, who lost a leg in an accident, used our app to find rehabilitation programs and prosthetic support. He is now a marathon runner and motivational speaker.'
    },
  ];

  SuccessStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false, // Removes the back arrow
        title: Center(
          child: Text(
            "SUCCESS STORIES <3",
            style: GoogleFonts.dancingScript(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.orange[50],
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SuccessStoryPopup(story: story),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFAF5B0), Color(0xFFFADF69)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: AssetImage(story['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story['quote']!,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '- ${story['name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SuccessStoryPopup extends StatefulWidget {
  final Map<String, String> story;

  const SuccessStoryPopup({super.key, required this.story});

  @override
  State<SuccessStoryPopup> createState() => _SuccessStoryPopupState();
}

class _SuccessStoryPopupState extends State<SuccessStoryPopup> {
  int likes = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.story['image']!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget.story['name']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.story['description']!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify, // Justify the text here
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          likes++;
                        });
                      },
                      icon: const Icon(Icons.thumb_up),
                      label: Text('Like ($likes)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}