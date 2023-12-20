import 'package:flutter/material.dart';
import 'package:flutter_hw_2/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String myApplicationTitle = "Weather flutter app";

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: myApplicationTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyAppContainer(title: myApplicationTitle),
    );
  }
}

class MyAppContainer extends StatelessWidget {
  const MyAppContainer({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(MyApp.myApplicationTitle),
      ),
      body: const MyHomePage(),
    );
  }
}
