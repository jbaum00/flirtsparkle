//Holy Code
import 'dart:async';

import 'package:borealis/database/databaseconfig.dart';
import 'package:borealis/database/databaseconnector.dart';
import 'package:borealis/models/chatblock.dart';
import 'package:borealis/screens/mainpage.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String characterName;

  const ChatPage({Key? key, required this.characterName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String characterName;
  late int currentindex;
  late List<String> messages;
  late List<String> answers;
  late List<String> responses;
  late int breakpoint;
  //late int delay;
  late List<String> id;
  List<ChatBlock> chatBlocks = [];
  List histolist = [];
  dynamic data;
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    characterName = widget.characterName;
    _initializeData();
  }

  void _initializeData() async {
    loadChatData();
    currentindex =
        await DataBaseConnector.getCurrenIndexPosition(characterName);
    if (currentindex == 0) {
      insertChatData();
    }
    _loadChatHistory();
  }

  void _loadChatHistory() async {
    final data = await DataBaseConnector.getChatHistory(characterName);
    setState(() {
      histolist = data;
    });
  }

  Future<void> loadChatData() async {
    data = await DataBaseConnector.readJsonChat(characterName);
    for (var blockData in data['data']) {
      List<String> messages = List<String>.from(blockData['messages']);
      List<String> answers = List<String>.from(blockData['answers']);
      List<String> responses = List<String>.from(blockData['response']);
      int breakpoint = blockData['breakpoint'];
      int delay = blockData['delay'];
      ChatBlock block =
          ChatBlock(messages, answers, responses, breakpoint, delay);
      chatBlocks.add(block);
    }
  }

  Future<void> insertChatData() async {
    if (currentindex == 0) {
      currentindex++;
      return;
    }
    var messages = chatBlocks[currentindex].messages;
    var breakpoint = chatBlocks[currentindex].breakpoint;
    currentindex++;
    for (int i = 0; i < messages.length; i++) {
      DataBaseConfig.insertChatHistoryEntry(
          characterName, currentindex, 0, messages[i], breakpoint);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainPage()), // Ersetzen Sie MainPage durch den tatsächlichen Namen Ihrer Startseite
              (Route<dynamic> route) =>
                  false, // Entfernt alle vorherigen Routen
            );
          },
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/Profiles/$characterName/$characterName.jpg'),
              radius: 20,
            ),
            const SizedBox(width: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                characterName,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 600,
                  child: ListView.builder(
                    itemCount: histolist.isNotEmpty ? histolist.length : 0,
                    itemBuilder: (context, index) {
                      return buildMessage(histolist[index]['message'],
                          histolist[index]['sender']);
                    },
                  ),
                ),
                if (chatBlocks.isNotEmpty &&
                    currentindex < chatBlocks.length) ...[
                  for (var entry
                      in chatBlocks[currentindex - 1].answers.asMap().entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: SizedBox(
                        width: 380,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.pink[400]!)),
                            onPressed: () async {
                              setState(() {
                                _isOverlayVisible = true;
                              });
                              await DataBaseConfig.insertChatHistoryEntry(
                                  characterName,
                                  currentindex,
                                  1,
                                  entry.value,
                                  0);
                              _loadChatHistory();
                              int delay = chatBlocks[currentindex - 1].delay;
                              await Future.delayed(Duration(seconds: delay));
                              await DataBaseConfig.insertChatHistoryEntry(
                                  characterName,
                                  currentindex,
                                  0,
                                  chatBlocks[currentindex - 1]
                                      .responses[entry.key],
                                  0);
                              insertChatData();
                              setState(() {
                                _initializeData();
                                _isOverlayVisible = false;
                              });
                            },
                            child: Text(
                              entry.value,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          if (_isOverlayVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 200,
              child: _buildOverlay(),
            ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    {
      return Container(
        color: Colors.white.withOpacity(1),
      );
    }
  }

  Widget buildMessage(String message, int sender) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Align(
        alignment: sender == 0 ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.6,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: sender == 0 ? Colors.grey[400] : Colors.pink[400],
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
