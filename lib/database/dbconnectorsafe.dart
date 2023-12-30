import 'dart:convert';

import 'package:borealis/database/databaseconfig.dart';
import 'package:flutter/services.dart';

class DataBaseConnector {
  // Holt alle Profile aus der Datenbank
  static Future<List<Map<String, dynamic>>> getProfiles() async {
    final db = await DataBaseConfig.db();
    return db.query('profiles', where: 'matched = 1', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getChats(String name) async {
    final db = await DataBaseConfig.db();
    return db.query('${name}chat', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getProfilList() async {
    final db = await DataBaseConfig.db();
    List<Map<String, dynamic>> profiles =
        await db.query('profiles', orderBy: "id");
    return profiles;
  }

  Future<void> updateProfileMatched(int profileId) async {
    final db = await DataBaseConfig.db();
    await db.update(
      'profiles',
      {'matched': 1}, // Setzen Sie das 'matched'-Feld auf 1
      where: 'id = ?',
      whereArgs: [profileId],
    );
  }

  static Future<List<Map<String, dynamic>>> getChatHistory(
      String profil) async {
    final db = await DataBaseConfig.db();
    List<Map<String, dynamic>> profiles =
        await db.query('${profil}chathistory', orderBy: "id");
    return profiles;
  }

  static Future<int> getCurrenIndexPosition(String profile) async {
    final db = await DataBaseConfig.db();
    var result = await db
        .rawQuery('SELECT MAX(blockid) as max_id FROM ${profile}chathistory');
    if (result.isNotEmpty) {
      return int.tryParse(result.first['max_id'].toString()) ?? 0;
    }
    return 0;
  }

  static Future<dynamic> readJsonChat(String profile) async {
    final String jsonString =
        await rootBundle.loadString('assets/Profiles/$profile/chat.json');
    final jsonData = json.decode(jsonString);
    return jsonData;
  }
}
