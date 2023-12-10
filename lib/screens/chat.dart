import 'dart:async';

import 'package:borealis/models/chatblock.dart';
import 'package:borealis/providers/databaseconfig.dart';
import 'package:borealis/providers/databaseconnector.dart';
import 'package:borealis/providers/jsonconnector.dart';
import 'package:flutter/material.dart';

//App muss mit Firebase verbunden werden um den Log zu lesen und zu speichern
//Gespeichter wird mit einer weiteren Datei für den momentanen Index

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
  late List<String> id;
  List<ChatBlock> chatBlocks = [];
  List histolist = [];
  dynamic data;

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
    data = await JsonConnector.readJsonChat(characterName);
    for (var blockData in data['data']) {
      List<String> messages = List<String>.from(blockData['messages']);
      List<String> answers = List<String>.from(blockData['answers']);
      List<String> responses = List<String>.from(blockData['response']);
      ChatBlock block = ChatBlock(messages, answers, responses);
      chatBlocks.add(block);
    }
  }

  Future<void> insertChatData() async {
    if (currentindex == 0) {
      currentindex++;
      return;
    }
    var messages = chatBlocks[currentindex].messages;
    currentindex++;
    for (int i = 0; i < messages.length; i++) {
      DataBaseConfig.insertChatHistoryEntry(
          characterName, currentindex, 0, messages[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.red,
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
      body: Container(
        /*decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Wallpaper/Wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),*/
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: histolist.isNotEmpty ? histolist.length : 0,
                itemBuilder: (context, index) {
                  return buildMessage(
                      histolist[index]['message'], histolist[index]['sender']);
                },
              ),
            ),
            if (chatBlocks.isNotEmpty && currentindex < chatBlocks.length) ...[
              for (var entry
                  in chatBlocks[currentindex - 1].answers.asMap().entries)
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.pink[400]!)),
                  onPressed: () async {
                    await DataBaseConfig.insertChatHistoryEntry(
                        characterName, currentindex, 1, entry.value);
                    _loadChatHistory();
                    Future.delayed(const Duration(seconds: 3), () async {
                      await DataBaseConfig.insertChatHistoryEntry(
                          characterName,
                          currentindex,
                          0,
                          chatBlocks[currentindex - 1].responses[entry.key]);
                      insertChatData();
                      setState(() {
                        _initializeData();
                      });
                    });
                  },
                  child: Text(entry.value),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildMessage(String message, int sender) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Align(
        alignment: sender == 0 ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // Setting the maximum width to half of the screen width
            maxWidth: MediaQuery.of(context).size.width / 1.6,
          ),
          child: Container(
            decoration: BoxDecoration(
              //sender == 0 ? Color.fromARGB(255, 27, 197, 112) : Colors.blue,
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
