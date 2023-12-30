import 'dart:async';
import 'dart:convert';

import 'package:borealis/database/databaseconnector.dart';
import 'package:borealis/models/chatblock.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart' as sql;

List<ChatBlock> chatBlocks = [];

class DataBaseConfig {
  const DataBaseConfig();

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'borealis.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTableProfiles(database);
        await insertTablesData(database);
      },
    );
  }

  static Future<void> createTableProfiles(sql.Database database) async {
    await database.execute("""CREATE TABLE profiles(
        id INTEGER PRIMARY KEY,
        name TEXT,
        bio TEXT,
        attribute TEXT,
        profileimagepath TEXT,
        matched INTEGER,
        finished INTEGER
      )
      """);
  }

  static Future<void> createChatHistoryTable(String profile) async {
    final data = await DataBaseConnector.readJsonChat(profile);
    sql.Database database = await db();
    //String profile = name;
    String tableName = "${profile}chathistory";

    var table = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [tableName]);

    if (table.isEmpty) {
      await database.execute("""
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        blockid INTEGER,
        sender INTEGER,
        message TEXT,
        breakpoint INTEGER,
        delay INTEGER
      )
    """);

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

      var messages = chatBlocks[0].messages;
      for (int i = 0; i < messages.length; i++) {
        DataBaseConfig.insertChatHistoryEntry(profile, 1, 0, messages[i], 0);
        chatBlocks.clear();
      }
    }
  }

  static Future<List<Map<String, dynamic>>> loadJsonDataFromAsset(
      String assetPath) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.cast<Map<String, dynamic>>();
  }

  static Future<void> insertData(
      sql.Database database, String tableName, String assetPath) async {
    final List<Map<String, dynamic>> data =
        await loadJsonDataFromAsset(assetPath);

    for (final entry in data) {
      await database.insert(tableName, entry,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<void> insertTablesData(sql.Database database) async {
    await insertData(database, 'profiles', 'assets/Profiles/profiles.json');
  }

  static insertChatHistoryEntry(String profile, int currentindex, int sender,
      String message, int breakpoint) async {
    final sql.Database database = await db();
    await database.insert(
        '${profile}chathistory',
        {
          'blockid': currentindex,
          'sender': sender,
          'message': message,
          'breakpoint': breakpoint,
          'delay': breakpoint,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
}
