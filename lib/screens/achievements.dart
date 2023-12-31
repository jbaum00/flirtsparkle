import 'package:flutter/material.dart';

import '../widgets/TopNavigationBar.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBarWidget('Achievements'),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ]),
        /*child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomNavigationBarWidget(),
          ],
        ),*/
      ),
    );
  }
}
