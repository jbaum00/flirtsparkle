import 'dart:async';

import 'package:borealis/widgets/BottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/TopNavigationBar.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Timer? _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _loadTimer();
  }

  void _setTimer(int durationInSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('startTime', now);
    await prefs.setInt(
        'duration', durationInSeconds * 1000); // Speichern in Millisekunden
    _loadTimer();
  }

  void _loadTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final startTime = prefs.getInt('startTime') ?? 0;
    final duration = prefs.getInt('duration') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    if (startTime + duration > now) {
      setState(() {
        _remainingTime = ((startTime + duration) - now) ~/ 1000;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBarWidget('Shop'),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Fügen Sie hier weitere Widgets ein
            Text('Willkommen im Shop!'),
            Text(
              'Verbleibende Zeit: $_remainingTime Sekunden',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () => _setTimer(60), // Startet einen 60-Sekunden-Timer
              child: Text('Timer Starten'),
            ),

            // Ihr existierendes Widget
            BottomNavigationBarWidget(),
            // Sie können hier weitere Widgets hinzufügen
          ],
        ),
      ),
    );
  }
}
