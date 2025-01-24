import 'package:flutter/material.dart';
import 'package:app_hk/course1_page.dart' as course1;
import 'package:app_hk/course2_page.dart' as course2;
import 'package:app_hk/course3_page.dart' as course3;
import 'package:app_hk/course4_page.dart' as course4;
import 'package:app_hk/course5_page.dart' as course5;
import 'package:app_hk/course6_page.dart' as course6;

class CoursePage extends StatelessWidget {
  final List<Map<String, dynamic>> courseBoxes = [
    {'image': 'assets/images/braile.png', 'gradient': [const Color.fromARGB(255, 22, 227, 227), const Color.fromARGB(255, 94, 243, 208)]},
    {'image': 'assets/images/help.png', 'gradient': [const Color(0xFFFDD26A), const Color(0xFFA77200)]},
    {'image': 'assets/images/skill.png', 'gradient': [const Color(0xFFFF0022), const Color(0xFFF37A00)]},
    {'image': 'assets/images/language.png', 'gradient': [const Color(0xFF00FF37), const Color(0xFF008526)]},
    {'image': 'assets/images/disabled.png', 'gradient': [const Color.fromARGB(255, 194, 64, 230), const Color.fromARGB(255, 211, 123, 235), const Color.fromARGB(255, 221, 172, 234)]},
    {'image': 'assets/images/share.png', 'gradient': [const Color.fromARGB(255, 24, 192, 230), const Color.fromARGB(255, 145, 130, 130)]},
  ];

  CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF191031),
        elevation: 0,
        title: const Text(
          'FIND YOUR COURSES',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CourseSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 380,
                height: 140,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '60% OFF',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'For New Year!',
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                          Spacer(),
                          Text(
                            'Gift Code: NY2025',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Image.asset(
                      'assets/images/gift.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Courses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle "See all" action
                    },
                    child: const Text('See all', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 140 / 170,
                ),
                itemCount: courseBoxes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      switch (index) {
                        case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => course1.CoursesPage1()),
                        );
                        break;
                        case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => course2.CoursesPage2()),
                        );
                        break;
                        case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => course3.CoursesPage3()),
                        );
                        case 3:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => course4.CoursesPage4()),
                        );
                        break;
                        case 4:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => course5.CoursesPage5()),
                        );
                        case 5:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => course6.CoursesPage6()),
                        );
                        break;
                        default:
                        // Handle other cases or do nothing
                        break;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: courseBoxes[index]['gradient'],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          courseBoxes[index]['image'],
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF191031),
    );
  }
}

class CourseSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search results for "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'Course 1',
      'Course 2',
      'Course 3',
    ].where((course) => course.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}