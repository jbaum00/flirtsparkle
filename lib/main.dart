import 'package:borealis/screens/shop.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ShopPage(title: 'Borelias/Shop'),
      debugShowCheckedModeBanner: false,
    );
  }
}
