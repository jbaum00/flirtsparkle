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
      /*theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          // ···
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.roboto(
            fontSize: 30,
            fontStyle: FontStyle.normal,
          ),
          bodyMedium: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal),
          displaySmall: GoogleFonts.roboto(),
        ),
      ),*/
      home: ShopPage(title: 'Borelias/Shop'),
      debugShowCheckedModeBanner: false,
    );
  }
}
