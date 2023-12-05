import 'package:borealis/models/chatblock.dart';
//import 'package:borealis/providers/jsonconnector.dart';

late String characterName;

late List<String> messages;
late List<String> answers;
late List<String> responses;
List<ChatBlock> chatBlocks = [];
dynamic data;

/*late List<String> logmessage;
List<dynamic> loglist = [];*/

//List<Chatlog> chatlog = [];

/*Future<void> loadChatData() async {
  data = await JsonConnector.readJsonChat();
  for (var blockData in data['data']) {
    List<String> messages = List<String>.from(blockData['messages']);
    List<String> answers = List<String>.from(blockData['answers']);
    List<String> responses = List<String>.from(blockData['response']);
    ChatBlock block = ChatBlock(messages, answers, responses);
    chatBlocks.add(block);
  }
}*/

/*Future<void> loadLogData() async {
  loglist = await JsonConnector.readJsonLog();
  //print(loglist);
  for (var entry in loglist) {
    logmessage.add(entry['message']);
    //Only msg print(entry['message']);
  }
}*/
