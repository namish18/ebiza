// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MTPage extends StatefulWidget {
  const MTPage({super.key});

  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MTPage> {
  final Map<DateTime, Color> moodColors = {};
  final Map<Color, String> moodLabels = {
    Colors.red: "Very Depressed",
    Colors.orange: "Depressed",
    Colors.yellow: "Neutral",
    Colors.lightGreen: "Happy",
    Colors.green: "Very Happy"
  };

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true, // Centers the title
        title: const Text(
          "MOOD TRACKER",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, // Makes the text bold
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Calendar
          TableCalendar(
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime.now(),
            focusedDay: today,
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                today = selectedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: moodColors[day] ?? Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: moodColors[day] ?? Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Today's Mood Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Today's Mood: ",
                style: TextStyle(fontSize: 16),
              ),
              GestureDetector(
                onTap: () => _showMoodPickerDialog(context, today),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: moodColors[today] ?? Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Mood of the Week and Month
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _moodSummarySection("Mood of the Week", _calculateMoodOfWeek()),
              _moodSummarySection("Mood of the Month", _calculateMoodOfMonth()),
            ],
          ),
          const SizedBox(height: 20),
          // Mood History
          Expanded(
            child: _moodHistorySection(),
          ),
          const SizedBox(height: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetMoodHistory,
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete),
      ),
    );
  }

  Widget _moodSummarySection(String title, Color moodColor) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: moodColor,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          moodLabels[moodColor] ?? "No Data",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _moodHistorySection() {
    final sortedDates = moodColors.keys.toList()..sort();
    if (sortedDates.isEmpty) {
      return const Center(
        child: Text(
          "No mood data available.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        return ListTile(
          leading: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: moodColors[date],
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            "${date.day}/${date.month}/${date.year}",
            style: const TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            moodLabels[moodColors[date]] ?? "",
            style: const TextStyle(fontSize: 14),
          ),
        );
      },
    );
  }

  void _showMoodPickerDialog(BuildContext context, DateTime date) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Today's Mood"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: moodLabels.keys.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    moodColors[date] = color;
                  });
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(moodLabels[color] ?? ""),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _resetMoodHistory() {
    setState(() {
      moodColors.clear();
    });
  }

  Color _calculateMoodOfWeek() {
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return _calculateDominantMood(weekStart, weekEnd);
  }

  Color _calculateMoodOfMonth() {
    final monthStart = DateTime(today.year, today.month, 1);
    final monthEnd = DateTime(today.year, today.month + 1, 0);

    return _calculateDominantMood(monthStart, monthEnd);
  }

  Color _calculateDominantMood(DateTime start, DateTime end) {
    final moodCount = <Color, int>{};

    for (var day = start; day.isBefore(end.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      final mood = moodColors[day];
      if (mood != null) {
        moodCount[mood] = (moodCount[mood] ?? 0) + 1;
      }
    }

    Color? dominantMood;
    int maxCount = 0;

    moodCount.forEach((color, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantMood = color;
      }
    });

    return dominantMood ?? Colors.grey;
  }
}