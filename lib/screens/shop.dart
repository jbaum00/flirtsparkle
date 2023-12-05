import 'package:borealis/widgets/BottomNavigationBar.dart';
import 'package:flutter/material.dart';

import '../widgets/TopNavigationBar.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
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
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomNavigationBarWidget(),
          ],
        ),
      ),
    );
  }
}
