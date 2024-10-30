import 'package:flutter/material.dart';

class GroupDetailsPage extends StatelessWidget {
  const GroupDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('群组详情'),
      ),
      body: const Center(
        child: Text('群组详情'),
      ),
    );
  }
}
