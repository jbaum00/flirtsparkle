import 'package:flutter/material.dart';

import '../widgets/BackgroundCurve.dart';
import '../widgets/CardStack.dart';

class SwipePage extends StatelessWidget {
  const SwipePage({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          BackgroudCurveWidget(),
          CardsStackWidget(),
        ],
      ),
    );
  }
}

enum Swipe { left, right, none }
