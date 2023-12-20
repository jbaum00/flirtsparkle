import 'package:borealis/widgets/TopNavigationBar.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  final String title;

  const ShopPage({Key? key, required this.title}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBarWidget('Shop'),
      body: const Center(
        child: Text(
          'Willkommen im Shop!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
