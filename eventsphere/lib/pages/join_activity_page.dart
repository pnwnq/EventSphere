import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/dice_widget.dart';
import '../services/activity_service.dart';

class JoinActivityPage extends StatefulWidget {
  const JoinActivityPage({Key? key}) : super(key: key);

  @override
  _JoinActivityPageState createState() => _JoinActivityPageState();
}

class _JoinActivityPageState extends State<JoinActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final _activityService = ActivityService();
  String _activityCode = '';

  void _rollDiceForCode() {
    setState(() {
      _activityCode = (1000 + Random().nextInt(9000)).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('加入活动'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: '活动代码'),
                      controller: TextEditingController(text: _activityCode),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入或随机生成活动代码';
                        }
                        return null;
                      },
                      onSaved: (value) => _activityCode = value!,
                    ),
                  ),
                  DiceWidget(onRoll: _rollDiceForCode),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // 这里我们模拟加入活动的过程
                    final activity = Activity(
                      id: _activityCode,
                      name: '模拟活动',
                      time: '模拟时间',
                      location: '模拟地点',
                      theme: '模拟主题',
                    );
                    await _activityService.saveJoinedActivity(activity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('成功加入活动！')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('加入活动'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
