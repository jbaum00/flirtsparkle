import 'package:borealis/firebase_options.dart';
import 'package:borealis/providers/chatlistmanager.dart';
import 'package:borealis/screens/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatListManager()),
      ],
      child: MaterialApp(
        home: MainPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
