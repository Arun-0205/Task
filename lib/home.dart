// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'sqlite.dart';

class CounterScreen extends StatefulWidget {
  final String username;
  const CounterScreen({super.key, required this.username});

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    int count = await _databaseHelper.getUserCount(widget.username);
    setState(() {
      _counter = count;
    });
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await _databaseHelper.updateUserCount(widget.username, _counter);
  }

  void _decreaseCounter() async {
    setState(() {
      _counter--;
    });
    await _databaseHelper.updateUserCount(widget.username, _counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[500],
      appBar: AppBar(
          title: Text(
        widget.username,
        style: TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$_counter',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            Text('Your Count',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: Text('Increase'),
                ),
                ElevatedButton(
                  onPressed: _decreaseCounter,
                  child: Text('Decrease'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
