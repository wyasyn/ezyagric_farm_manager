import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EzyAgricApp());
}

class EzyAgricApp extends StatelessWidget {
  const EzyAgricApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EzyAgric Farm Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
