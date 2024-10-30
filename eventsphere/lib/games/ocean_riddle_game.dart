import 'package:flutter/material.dart';

class OceanRiddleGame extends StatelessWidget {
  const OceanRiddleGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('海洋谜题'),
      ),
      body: const Center(
        child: Text('海洋谜题游戏'),
      ),
    );
  }
}
