import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Master Exit Button Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Master Exit Button Demo'),
        ),
        body: SignupSection(),
      ),
    );
  }
}

class SignupSection extends StatefulWidget {
  @override
  _SignupSectionState createState() => _SignupSectionState();
}

class _SignupSectionState extends State<SignupSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Your signup widgets here

          SizedBox(height: 16),

          MasterExitButton(),
        ],
      ),
    );
  }
}

class MasterExitButton extends StatefulWidget {
  @override
  _MasterExitButtonState createState() => _MasterExitButtonState();
}

class _MasterExitButtonState extends State<MasterExitButton> {
  bool _isExitEnabled = false;
  bool _isPasscodePopupVisible = false;
  bool _isTimerRunning = false;
  int _remainingTime = 3600; // 1 hour in seconds

  void _enableExit() {
    setState(() {
      _isExitEnabled = true;
    });
  }

  void _showPasscodePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Passcode'),
          content: TextField(
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            onChanged: (value) {
              if (value == '1234') {
                Navigator.of(context).pop();
                _enableExit();
                _startTimer();
              }
            },
          ),
        );
      },
    );
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
    });

    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_remainingTime == 0) {
          timer.cancel();
          _disableExit();
        } else {
          setState(() {
            _remainingTime--;
          });
        }
      },
    );
  }

  void _disableExit() {
    setState(() {
      _isExitEnabled = false;
      _isTimerRunning = false;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final secondsFormatted = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secondsFormatted';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _isExitEnabled ? () => exit(0) : _showPasscodePopup,
          child: Text('Master Exit'),
        ),
        if (_isTimerRunning)
          Text(
            'Time Remaining: ${_formatDuration(_remainingTime)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
