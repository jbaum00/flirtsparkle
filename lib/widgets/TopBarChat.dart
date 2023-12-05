/*import 'package:flutter/material.dart';

class TopBarChatWidget extends StatelessWidget implements PreferredSizeWidget {
  //ChatPage({required this.characterName});
  final String characterName;
  TopBarChatWidget({required this.characterName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[900], // Hintergrundfarbe
      title: const Align(
        alignment: Alignment.centerLeft, // Text links ausrichten
        child: Text(
          'characterName',
          style: TextStyle(
            color: Colors.white, // Schriftfarbe
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        // Zurück-Button
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Hier können Sie die Aktion definieren, die beim Klicken auf den Zurück-Button ausgeführt werden soll.
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
*/