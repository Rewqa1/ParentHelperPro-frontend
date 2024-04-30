import 'package:flutter/material.dart';

class HintParenting extends StatelessWidget {
  const HintParenting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Советы'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text('Советы по воспитанию'),
      ),
    );
  }
}