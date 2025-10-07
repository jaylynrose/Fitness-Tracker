import 'package:flutter/material.dart';
import 'home_page.dart';
void main() {
  runApp(const FitnessApp());
}
class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}


