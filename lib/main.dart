import 'package:flutter/material.dart';
import 'package:nativenadi/homepage.dart';
import 'package:flutter_app_icons/flutter_app_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final flutterAppIconsPlugin = FlutterAppIcons();
    flutterAppIconsPlugin.setIcon(icon: 'assets/images/T.png');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Terrascript',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
    );
  }
}
