//State-Management 29.12.23
/*import 'dart:async';

import 'package:borealis/database/databaseconfig.dart';
import 'package:borealis/database/databaseconnector.dart';
import 'package:borealis/models/chatblock.dart';
import 'package:borealis/providers/chatmanager.dart';
import 'package:borealis/screens/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String characterName;

  const ChatPage({Key? key, required this.characterName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String characterName;
  late int currentindex = 0;
  late List<ChatBlock> chatBlocks;
  bool isAwaitingResponse = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    characterName = widget.characterName;
    chatBlocks = [];
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadChatData();
    await loadInitialChatMessages();
    //Provider.of<ChatManager>(context, listen: false).loadChats();
  }

  Future<void> loadCurrentBlockMessages() async {
    var messages = chatBlocks[currentindex - 1].messages;
    for (String message in messages) {
      await DataBaseConfig.insertChatHistoryEntry(
          characterName, currentindex, 0, message, 0);
    }
  }

  Future<void> loadChatData() async {
    var data = await DataBaseConnector.readJsonChat(characterName);
    for (var blockData in data['data']) {
      List<String> messages = List<String>.from(blockData['messages']);
      List<String> answers = List<String>.from(blockData['answers']);
      List<String> responses = List<String>.from(blockData['response']);
      int breakpoint = blockData['breakpoint'];
      int delay = blockData['delay'];
      chatBlocks
          .add(ChatBlock(messages, answers, responses, breakpoint, delay));
    }
  }

  Future<void> loadInitialChatMessages() async {
    final chatManager = Provider.of<ChatManager>(context, listen: false);
    var messages = chatBlocks[currentindex].messages;
    for (String message in messages) {
      chatManager.addMessage(characterName, message, 0);
      await DataBaseConfig.insertChatHistoryEntry(
          characterName, currentindex + 1, 0, message, 0);
    }
    currentindex++;
  }

  void onUserResponse(String response) async {
    final chatManager = Provider.of<ChatManager>(context, listen: false);

    // Füge die Nutzerantwort hinzu und aktualisiere die Datenbank
    chatManager.addMessage(characterName, response, 1);
    await DataBaseConfig.insertChatHistoryEntry(
        characterName, currentindex, 1, response, 0);

    // Berechne die Bot-Antwort und füge sie nach der Verzögerung hinzu
    int responseIndex = chatBlocks[currentindex - 1].answers.indexOf(response);
    if (responseIndex != -1) {
      String botResponse =
          chatBlocks[currentindex - 1].responses[responseIndex];
      Timer(Duration(seconds: chatBlocks[currentindex - 1].delay), () async {
        chatManager.addMessage(characterName, botResponse, 0);
        await DataBaseConfig.insertChatHistoryEntry(
            characterName, currentindex, 0, botResponse, 0);

        // Gehe zum nächsten Block, wenn vorhanden
        if (currentindex < chatBlocks.length) {
          await loadNextBlockMessages();
          currentindex++;
        }
        setState(() {});
      });
    }
  }

  Future<void> loadNextBlockMessages() async {
    final chatManager = Provider.of<ChatManager>(context, listen: false);
    var messages = chatBlocks[currentindex].messages;
    for (String message in messages) {
      chatManager.addMessage(characterName, message, 0);
      await DataBaseConfig.insertChatHistoryEntry(
          characterName, currentindex + 1, 0, message, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages =
        Provider.of<ChatManager>(context).getChatMessages(characterName);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainPage()),
            (Route<dynamic> route) => false,
          ),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/Profiles/$characterName/$characterName.jpg'),
              radius: 20,
            ),
            SizedBox(width: 20),
            Text(characterName,
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      return buildMessage(chatMessages[index].message,
                          chatMessages[index].sender);
                    },
                  ),
                ),
                if (!isAwaitingResponse && currentindex <= chatBlocks.length)
                  buildAnswerButtons(chatBlocks[currentindex - 1].answers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(String message, int sender) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Align(
        alignment: sender == 0 ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.6),
          child: Container(
            decoration: BoxDecoration(
              color: sender == 0 ? Colors.grey[400] : Colors.pink[400],
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(message,
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
        ),
      ),
    );
  }

  Widget buildAnswerButtons(List<String> answers) {
    return Column(
      children: answers
          .map((answer) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: 380,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.pink[400]!)),
                    onPressed: () => onUserResponse(answer),
                    child: Text(answer,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class ChatMessage {
  String message;
  int sender; // 0 für Bot, 1 für Nutzer

  ChatMessage({required this.message, required this.sender});
}
*/