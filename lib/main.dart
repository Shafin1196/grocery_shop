import 'package:flutter/material.dart';
import 'package:shoping_grocery/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromARGB(255, 147, 229, 250),
        brightness: Brightness.dark,
        surface: Color.fromARGB(255, 42, 51, 59),
      ),
      ),
      home:Home(),
    );
  }
}

