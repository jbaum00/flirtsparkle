import 'package:flutter/material.dart';

import '../screens/achievements.dart';
import '../screens/chatlist.dart';
import '../screens/premium.dart';
import '../screens/shop.dart';
import '../screens/swipe.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ShopPage(title: 'ShopPage'),
    const AchievementPage(title: 'Achievement'),
    const SwipePage(title: 'SwipePage'),
    const PremiumPage(title: 'PremiumPage'),
    const ChatListPage(title: 'Chats'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavBarItem(0, Icons.diamond_outlined),
          buildNavBarItem(1, Icons.military_tech_outlined),
          buildNavBarItem(2, Icons.style),
          buildNavBarItem(3, Icons.electric_bolt_outlined),
          buildNavBarItem(4, Icons.textsms_outlined),
        ],
      ),
    );
  }

  Widget buildNavBarItem(int index, IconData icon) {
    return IconButton(
      //color: _selectedIndex == index ? Colors.red : Colors.grey,
      color: Colors.red,
      icon: Icon(icon),
      onPressed: () {
        if (_selectedIndex != index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => _pages[index]));
        }
      },
    );
  }
}
