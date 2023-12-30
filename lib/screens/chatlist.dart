import 'package:borealis/providers/chatlistmanager.dart';
import 'package:borealis/screens/chat.dart';
import 'package:borealis/screens/profil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/TopNavigationBar.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    // Zugriff auf den ChatManager, um die aktuelle Chat-Liste zu erhalten
    final chatList = Provider.of<ChatListManager>(context).chatList;

    return Scaffold(
      appBar: TopAppBarWidget('FlirtSparkle'),
      backgroundColor: Colors.white,
      body: chatList.isEmpty
          ? const Center(child: Text("Mach dein erstes Match!"))
          : Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        final item = chatList[index];
                        return InkWell(
                          highlightColor: Colors.grey[100],
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ChatPage(
                                          characterName: chatList[index]
                                              ['name']),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0,
                                        0.0); // Beginn rechts außerhalb des Bildschirms
                                    const end = Offset
                                        .zero; // Endet genau im Bildschirmbereich
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ));
                          },
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProfilPage(
                                        characterName: item['name']);
                                  }));
                                },
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.asset(
                                      item['profileimagepath'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  textColor: Colors.red,
                                  title: Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  subtitle: Text(item['bio']),
                                  trailing: const SizedBox(
                                    width: 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
