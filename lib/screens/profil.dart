import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  final String characterName;

  const ProfilPage({Key? key, required this.characterName}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late String characterName = widget.characterName;
  final List<String> imagePaths = [
    'assets/Profiles/Sarah/Sarah1.jpg',
    'assets/Profiles/Sarah/Sarah2.jpg',
    'assets/Profiles/Sarah/Sarah3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildImagesTab() {
    return GridView.builder(
      physics:
          const BouncingScrollPhysics(), // Ermöglicht das Scrollen in der GridView
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              imagePaths[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget buildAudiosTab() {
    // Hier die Logik für Audios implementieren
    return Center(child: Text('Audios'));
  }

  Widget buildDatesTab() {
    // Hier die Logik für Dates implementieren
    return Center(child: Text('Dates'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          CircleAvatar(
            radius: 50,
            backgroundImage:
                AssetImage('assets/Profiles/$characterName/$characterName.jpg'),
          ),
          const SizedBox(height: 10),
          Text(
            widget.characterName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Hier die Aktion für den Unmatch-Button implementieren
            },
            child: const Text('Unmatch'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Pictures'),
              Tab(text: 'Audios'),
              Tab(text: 'Dates'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildImagesTab(),
                buildAudiosTab(),
                buildDatesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
