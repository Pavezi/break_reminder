import 'package:flutter/material.dart';
import 'break_timer.dart';

void main() {
  runApp(const BreakReminderApp());
}

class BreakReminderApp extends StatelessWidget {
  const BreakReminderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Break Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BreakTimer(),
    );
  }
}
