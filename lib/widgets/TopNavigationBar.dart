import 'package:flutter/material.dart';

class TopAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  TopAppBarWidget(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: const TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 28)),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
