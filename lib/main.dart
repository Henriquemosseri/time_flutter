import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'select_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Favorito',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/select': (context) => const SelectScreen(),
      },
    );
  }
}
