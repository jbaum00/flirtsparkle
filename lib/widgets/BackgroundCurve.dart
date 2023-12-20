import 'package:flutter/material.dart';

class BackgroudCurveWidget extends StatelessWidget {
  const BackgroudCurveWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 750,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        gradient: LinearGradient(
          /*colors: <Color>[
            Color(0xFF110E42),
            Color.fromARGB(255, 15, 195, 186),
          ],*/
          colors: <Color>[
            Color.fromARGB(255, 207, 27, 132),
            Color.fromARGB(255, 15, 195, 186),
          ],
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 46.0, left: 20.0),
        child: Text(
          'Get your match!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
