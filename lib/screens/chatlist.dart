import 'package:borealis/screens/chat.dart';
import 'package:flutter/material.dart';

import '../providers/databaseconnector.dart';
import '../widgets/BottomNavigationBar.dart';
import '../widgets/TopNavigationBar.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key, required String title}) : super(key: key);
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> chatlist = [];

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DataBaseConnector.getProfiles();
    setState(() {
      chatlist = data;
      _isLoading = false;
    });
  }

  //Loading data on page call
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBarWidget('Chats'),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : chatlist.isEmpty
              ? const Center(child: Text("No Data Available!!!"))
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListView.builder(
                          itemCount: chatlist.length,
                          itemBuilder: (context, index) => InkWell(
                            highlightColor: Colors.grey[100],
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatPage(
                                    characterName: chatlist[index]['name']);
                                //return ChatTestPage();
                              }));
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        40), // Die Hälfte der Breite/Höhe für volle Rundung
                                    child: Image.asset(
                                      chatlist[index]['profileimagepath'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    textColor: Colors.red,
                                    title: Text(
                                      chatlist[index]['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    subtitle: Text(chatlist[index]['bio']),
                                    trailing: const SizedBox(
                                      width: 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Hier fügen Sie einen zusätzlichen Container hinzu:
                    const SizedBox(
                      // Geben Sie hier die Eigenschaften für den Container an

                      height: 100, // Ändern Sie die Höhe nach Bedarf
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BottomNavigationBarWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
