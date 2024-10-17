import 'dart:math';
import 'package:flutter/material.dart';

class OceanRiddleGame extends StatefulWidget {
  @override
  _OceanRiddleGameState createState() => _OceanRiddleGameState();
}

class _OceanRiddleGameState extends State<OceanRiddleGame> {
  final List<Map<String, String>> _riddles = [
    {"question": "我有鳍和鳞，但不是鱼。我能在水中游泳，但也能在陆地上行走。我是什么？", "answer": "海豹"},
    {"question": "我是海洋中最大的哺乳动物，但我不吃鱼。我是什么？", "answer": "蓝鲸"},
    {"question": "我有八条腿，但不是章鱼。我生活在海底，但不是鱼。我是什么？", "answer": "螃蟹"},
    {"question": "我能发光，但不是灯。我生活在深海，但不是鱼。我是什么？", "answer": "水母"},
    {"question": "我有坚硬的外壳，但不是龟。我生活在珊瑚礁中，但不是鱼。我是什么？", "answer": "贝壳"},
  ];

  late Map<String, String> _currentRiddle;
  String _userAnswer = '';
  bool _isCorrect = false;
  bool _hasAnswered = false;

  @override
  void initState() {
    super.initState();
    _selectNewRiddle();
  }

  void _selectNewRiddle() {
    setState(() {
      _currentRiddle = _riddles[Random().nextInt(_riddles.length)];
      _userAnswer = '';
      _isCorrect = false;
      _hasAnswered = false;
    });
  }

  void _checkAnswer() {
    setState(() {
      _isCorrect = _userAnswer.toLowerCase() == _currentRiddle['answer']!.toLowerCase();
      _hasAnswered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('海洋猜谜游戏'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentRiddle['question']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: '你的答案',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _userAnswer = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text('提交答案'),
            ),
            if (_hasAnswered)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _isCorrect ? '回答正确！' : '回答错误。正确答案是：${_currentRiddle['answer']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isCorrect ? Colors.green : Colors.red,
                  ),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectNewRiddle,
              child: Text('下一题'),
            ),
          ],
        ),
      ),
    );
  }
}
