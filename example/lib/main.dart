import 'package:flutter/material.dart';
import 'playground_page.dart';

void main() {
  runApp(const MorphingButtonApp());
}

class MorphingButtonApp extends StatelessWidget {
  const MorphingButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morphing Buttons',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PlaygroundPage(),
    );
  }
}
