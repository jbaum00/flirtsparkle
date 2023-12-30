import 'package:borealis/database/databaseconfig.dart';
import 'package:borealis/providers/chatpageprovider.dart';
import 'package:borealis/screens/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final String characterName;

  const ChatPage({Key? key, required this.characterName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatPageProvider(characterName),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.red),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            backgroundColor: Colors.white,
            title: _buildTitle(context),
          ),
          body: Consumer<ChatPageProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  _buildChatList(provider),
                  if (provider.isOverlayVisible) _buildOverlay(),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  Row _buildTitle(BuildContext context) {
    final provider = Provider.of<ChatPageProvider>(context, listen: false);
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(
              'assets/Profiles/${provider.characterName}/${provider.characterName}.jpg'),
          radius: 20,
        ),
        const SizedBox(width: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            provider.characterName,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatList(ChatPageProvider provider) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:
                  provider.histolist.isNotEmpty ? provider.histolist.length : 0,
              itemBuilder: (context, index) {
                return buildMessage(
                    context,
                    provider.histolist[index]['message'],
                    provider.histolist[index]['sender']);
              },
            ),
          ),
          if (provider.chatBlocks.isNotEmpty &&
              provider.currentindex < provider.chatBlocks.length)
            _buildAnswerButtons(provider),
        ],
      ),
    );
  }

  Widget _buildAnswerButtons(ChatPageProvider provider) {
    return Column(
      children: provider.chatBlocks[provider.currentindex - 1].answers
          .asMap()
          .entries
          .map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: 380,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.pink[400]!)),
                    onPressed: () async {
                      provider.isOverlayVisible = true;

                      // Einfügen der Benutzerantwort
                      await DataBaseConfig.insertChatHistoryEntry(characterName,
                          provider.currentindex, 1, entry.value, 0);
                      provider.loadChatHistory();

                      // Antwortverzögerung und Einfügen der automatischen Antwort
                      int delay =
                          provider.chatBlocks[provider.currentindex - 1].delay;
                      await Future.delayed(Duration(seconds: delay));
                      await DataBaseConfig.insertChatHistoryEntry(
                          characterName,
                          provider.currentindex,
                          0,
                          provider.chatBlocks[provider.currentindex - 1]
                              .responses[entry.key],
                          0);

                      // Aktualisieren des Zustands und Laden neuer Daten

                      provider.insertChatData();
                      provider.loadChatHistory();
                      provider.isOverlayVisible = false;
                    },
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 200,
      child: Container(
        color: Colors.white.withOpacity(1),
      ),
    );
  }

  Widget buildMessage(BuildContext context, String message, int sender) {
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
