import 'package:borealis/widgets/BottomNavigationBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 13, 13, 13),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 13, 13, 13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //NavBar
            BottomNavigationBarWidget(),
          ],
        ),
      ),
    );
  }
}
