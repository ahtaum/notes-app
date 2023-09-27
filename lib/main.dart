import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'route_tab.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
      home: DefaultTabController(
        length: AppRouteTab.tabPages.length, // Menggunakan panjang dari tabPages di route_tab.dart
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Notes'),
            bottom: TabBar(
              tabs: AppRouteTab.tabs, // Menggunakan tabs dari route_tab.dart
            ),
          ),
          body: TabBarView(
            children: AppRouteTab.tabPages, // Menggunakan tabPages dari route_tab.dart
          ),
        ),
      ),
    );
  }
}
