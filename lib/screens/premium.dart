import 'package:flutter/material.dart';

import '../widgets/TopNavigationBar.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBarWidget('Premium'),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(
                  'assets/Wallpaper/WallpaperPremium.jpg'), // Hier 'background_image.png' durch Ihren Bildpfad ersetzen
              fit: BoxFit.cover, // Je nach Bedarf können Sie 'fit' anpassen
            ),
            boxShadow: [
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
