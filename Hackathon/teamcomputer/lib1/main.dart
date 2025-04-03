import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MilestoneMapApp());
}

class MilestoneMapApp extends StatelessWidget {
  const MilestoneMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MilestoneMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
