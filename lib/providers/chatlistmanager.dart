import 'package:borealis/database/databaseconnector.dart';
import 'package:flutter/material.dart';

class ChatListManager with ChangeNotifier {
  List<Map<String, dynamic>> chatList = [];

  ChatListManager() {
    loadInitialData();
  }

  void updateChatList(List<Map<String, dynamic>> newList) {
    chatList = newList;
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    chatList = await DataBaseConnector.getMatches();
    notifyListeners();
  }

  Future<void> updateChatListAfterMatch() async {
    // Laden Sie die aktualisierte Liste der Profile
    final updatedChatList = await DataBaseConnector.getMatches();
    updateChatList(updatedChatList);
  }
}
