import 'dart:convert';

import 'package:flutter/services.dart';

class JsonConnector {
  static Future<dynamic> readJsonChat(String profile) async {
    final String jsonString =
        await rootBundle.loadString('assets/Profiles/$profile/chat.json');
    final jsonData = json.decode(jsonString);
    return jsonData;
  }
}
