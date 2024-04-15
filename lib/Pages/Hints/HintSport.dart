import 'package:flutter/material.dart';

class HintSport extends StatelessWidget {
  const HintSport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Советы'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text('Советы по спорту'),
      ),
    );
  }
}