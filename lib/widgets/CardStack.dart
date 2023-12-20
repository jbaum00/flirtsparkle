import 'package:borealis/providers/databaseconfig.dart';
import 'package:borealis/providers/databaseconnector.dart';
import 'package:borealis/screens/chat.dart';
import 'package:flutter/material.dart';

import '../models/profiles.dart';
import '../screens/swipe.dart';
import 'ActionButton.dart';
import 'Drag.dart';

class CardsStackWidget extends StatefulWidget {
  const CardsStackWidget({Key? key}) : super(key: key);

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> data = [];
  List<Profile> draggableItems = [];
  final databaseConnector = DataBaseConnector();
  bool isMatch = false;

  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        draggableItems.removeLast();
        _animationController.reset();

        swipeNotifier.value = Swipe.none;
      }
    });
  }

  // Methode zum Laden von Daten aus der Datenbank
  Future<void> _loadData() async {
    data = await DataBaseConnector.getProfilList();
    setState(() {
      draggableItems = data
          .where((profileData) => profileData['matched'] == 0) // Filterung
          .map((profileData) {
        return Profile(
            id: profileData['id'],
            name: profileData['name'],
            profileimagepath: profileData['profileimagepath'],
            attribute: profileData['attribute'],
            bio: profileData['bio'],
            matched: profileData['matched'],
            finished: profileData['finished']);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isMatch) {
      return _buildMatchScreen(); // Anzeigen des Match-Bildschirms
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ValueListenableBuilder(
            valueListenable: swipeNotifier,
            builder: (context, swipe, _) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: List.generate(draggableItems.length, (index) {
                if (index == draggableItems.length - 1) {
                  return PositionedTransition(
                    rect: RelativeRectTween(
                      begin: RelativeRect.fromSize(
                          const Rect.fromLTWH(0, 0, 580, 340),
                          const Size(580, 340)),
                      end: RelativeRect.fromSize(
                          Rect.fromLTWH(
                              swipe != Swipe.none
                                  ? swipe == Swipe.left
                                      ? -300
                                      : 300
                                  : 0,
                              0,
                              580,
                              340),
                          const Size(580, 340)),
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    )),
                    child: RotationTransition(
                      turns: Tween<double>(
                              begin: 0,
                              end: swipe != Swipe.none
                                  ? swipe == Swipe.left
                                      ? -0.1 * 0.3
                                      : 0.1 * 0.3
                                  : 0.0)
                          .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve:
                              const Interval(0, 0.4, curve: Curves.easeInOut),
                        ),
                      ),
                      child: DragWidget(
                        profile: draggableItems[index],
                        index: index,
                        swipeNotifier: swipeNotifier,
                        isLastCard: true,
                      ),
                    ),
                  );
                } else {
                  return DragWidget(
                    profile: draggableItems[index],
                    index: index,
                    swipeNotifier: swipeNotifier,
                  );
                }
              }),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 46.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButtonWidget(
                  onPressed: () {
                    swipeNotifier.value = Swipe.left;
                    _animationController.forward();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 20),
                ActionButtonWidget(
                  onPressed: () async {
                    swipeNotifier.value = Swipe.right;
                    _animationController.forward();
                    final currentProfile = draggableItems.last;
                    databaseConnector.updateProfileMatched(currentProfile.id);
                    await DataBaseConfig.createChatHistoryTable(
                        currentProfile.name);

                    setState(() {
                      isMatch =
                          true; // Setzen Sie isMatch auf true, wenn nach rechts gewischt wurde
                    });
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              setState(() {
                draggableItems.removeAt(index);
              });
            },
          ),
        ),
        Positioned(
          right: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              setState(() {
                draggableItems.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMatchScreen() {
    final currentProfile =
        draggableItems.last; // Profil, das gerade gematcht wurde

    return Scaffold(
      bottomNavigationBar: null,
      body: GestureDetector(
        onTap: () {
          setState(() {
            isMatch = false; // Zurücksetzen des Match-Status beim Tippen
          });
        },
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  currentProfile.profileimagepath,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const SizedBox(height: 400),
                    Text(
                      "IT'S A MATCH!",
                      style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[400],
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(characterName: currentProfile.name),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.pink[400],
                        backgroundColor:
                            Colors.white, // Rosa Schriftfarbe beim Drücken
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 16), // Größerer Button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Abgerundete Ecken
                        ),
                      ),
                      child: Text(
                        'CHAT NOW',
                        style: TextStyle(
                          color: Colors.pink[400], // Rosa Schrift
                          fontSize: 20, // Kleinere Schriftgröße
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
