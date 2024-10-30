import 'package:flutter/material.dart';

class GroupMembersPage extends StatelessWidget {
  const GroupMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('群组成员'),
      ),
      body: const Center(
        child: Text('成员列表'),
      ),
    );
  }
}
