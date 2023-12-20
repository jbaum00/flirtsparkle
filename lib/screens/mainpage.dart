import 'package:borealis/screens/firebaselogin.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'achievements.dart';
import 'premium.dart';
import 'shop.dart';
import 'swipe.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ShopPage(title: 'ShopPage'),
    AchievementPage(title: 'Achievement'),
    SwipePage(title: 'Swipe'),
    PremiumPage(title: 'PremiumPage'),
    FirebaseLoginExample(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        backgroundColor: Colors.pink[400],
        items: const [
          TabItem(icon: Icons.diamond, title: 'Shop'),
          TabItem(icon: Icons.military_tech_outlined, title: 'Achievements'),
          TabItem(icon: Icons.style, title: 'Swipe'),
          TabItem(icon: Icons.star, title: 'PremiumPage'),
          //TabItem(icon: Icons.textsms_outlined, title: 'Chats'),
          TabItem(icon: Icons.g_translate, title: 'Firebase'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
