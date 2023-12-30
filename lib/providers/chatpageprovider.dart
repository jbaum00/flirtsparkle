import 'package:borealis/database/databaseconfig.dart';
import 'package:borealis/database/databaseconnector.dart';
import 'package:flutter/material.dart';

import '../models/chatblock.dart';

class ChatPageProvider with ChangeNotifier {
  late String characterName;
  int currentindex = 0;
  List<ChatBlock> chatBlocks = [];
  List histolist = [];
  bool _isOverlayVisible = false;

  ChatPageProvider(this.characterName) {
    _initializeData();
  }

  void _initializeData() async {
    loadChatData();
    currentindex =
        await DataBaseConnector.getCurrenIndexPosition(characterName);
    if (currentindex == 0) {
      insertChatData();
    }
    loadChatHistory();
  }

  void loadChatHistory() async {
    final data = await DataBaseConnector.getChatHistory(characterName);
    histolist = data;
    notifyListeners();
  }

  Future<void> loadChatData() async {
    var data = await DataBaseConnector.readJsonChat(characterName);
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

  /*Future<void> insertest() async {
    DataBaseConfig.insertChatHistoryEntry(profile, currentindex, sender, message, breakpoint);
  }*/

  // ... (Rest der Methoden, wie loadChatData und insertChatData)

  bool get isOverlayVisible => _isOverlayVisible;
  set isOverlayVisible(bool value) {
    _isOverlayVisible = value;
    notifyListeners();
  }
}
