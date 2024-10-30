import 'package:flutter/material.dart';

class JoinActivityPage extends StatelessWidget {
  const JoinActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('加入活动'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '活动代码',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: null,
              child: Text('加入活动'),
            ),
          ],
        ),
      ),
    );
  }
}
