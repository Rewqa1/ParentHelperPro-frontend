import 'package:flutter/material.dart';

class HintGames extends StatelessWidget {
  const HintGames({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Советы'),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
      ),
      body: const Center(
        child: Text('Советы по играм'),
      ),
    );
  }
}