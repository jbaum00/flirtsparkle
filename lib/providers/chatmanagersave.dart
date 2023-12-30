//Stand 29.12.2023 22:40
import 'package:borealis/database/databaseconnector.dart';
import 'package:flutter/material.dart';

class ChatManager with ChangeNotifier {
  Map<String, List<ChatMessage>> chats = {};

  ChatManager() {
    loadChats();
  }

  //Lädt die Chat-Verläufe für alle Charaktere,
  //die in der Datenbank als "Matches" gekennzeichnet sind.
  Future<void> loadChats() async {
    final likedCharacters = await DataBaseConnector.getMatches();
    for (var character in likedCharacters) {
      var chatHistory =
          await DataBaseConnector.getChatHistory(character['name']);
      //Für jeden Charakter wird die Chat-Historie aus der Datenbank geladen und
      //als ChatMessage-Objekte in chats gespeichert.
      chats[character['name']] = chatHistory.map((chatData) {
        return ChatMessage(
          message: chatData['message'],
          sender: chatData['sender'],
        );
      }).toList();
    }
    notifyListeners();
  }

  //Fügt eine neue Nachricht zum Chatverlauf eines bestimmten Charakters hinzu.
  void addMessage(String characterName, String message, int sender) {
    final chatMessage = ChatMessage(message: message, sender: sender);
    if (!chats.containsKey(characterName)) {
      chats[characterName] = [];
    }
    chats[characterName]!.add(chatMessage);
    notifyListeners();
  }

  List<ChatMessage> getChatMessages(String characterName) {
    return chats[characterName] ?? [];
  }

  // Weitere Methoden zum Laden, Speichern und Aktualisieren von Chat-Daten
}

class ChatMessage {
  String message;
  int sender; // 0 für Bot, 1 für Nutzer

  ChatMessage({required this.message, required this.sender});
}
