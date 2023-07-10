// You need to import the necessary packages
import 'package:flutter/material.dart';
import 'dart:async';
import 'database_helper.dart';
import 'history_page.dart'; // add this

// Import your HistoryPage class
// import 'path_to_your_history_page.dart'; // replace with your actual path

// Create your DatabaseHelper class here (or import it from another file if you've defined it elsewhere)
// import 'path_to_your_database_helper.dart'; // replace with your actual path

class BreakTimer extends StatefulWidget {
  const BreakTimer({Key? key}) : super(key: key);

  @override
  _BreakTimerState createState() => _BreakTimerState();
}

class _BreakTimerState extends State<BreakTimer> {
  Timer? _timer;
  int doneCount = 0;
  int wontDoCount = 0;
  bool _isStarted = false;

  void recordStop() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnDate: DateTime.now().toIso8601String(),
      DatabaseHelper.columnStops: 1 // or the number of stops completed
    };
    final id = await DatabaseHelper.instance.insert(row);
    print('inserted row id: $id');
  }

  void startTimer() {
    _isStarted = true;
    _timer = Timer.periodic(
      const Duration(minutes: 1), // use 30 minutes instead of 1 second
      (timer) {
        if (!_isStarted) {
          timer.cancel();
        } else {
          // Reminder logic here, replaced 'print' with a debugPrint
          debugPrint('30 minutes passed');
          _isStarted = false;
          recordStop(); // add this line here
        }
      },
    );
  }

  void showDoneOrWontDoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Did you take the break?'),
          content: const Text('Choose your answer.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                ); // remove extra semicolon
                setState(() {
                  doneCount += 1;
                  Navigator.of(context).pop();
                  startTimer();
                });
              },
            ),
            TextButton(
              child: const Text('Won\'t do'),
              onPressed: () {
                setState(() {
                  wontDoCount += 1;
                  Navigator.of(context).pop();
                  startTimer();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Break Reminder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Done: $doneCount, Won\'t do: $wontDoCount'),
            ElevatedButton(
              child: Text(_isStarted ? 'Stop' : 'Start'),
              onPressed: () {
                setState(() {
                  if (_isStarted) {
                    _isStarted = false;
                    _timer?.cancel();
                  } else {
                    startTimer();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
