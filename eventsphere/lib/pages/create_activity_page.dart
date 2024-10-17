import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/dice_widget.dart';
import '../services/activity_service.dart';
import '../services/notification_service.dart';

class CreateActivityPage extends StatefulWidget {
  const CreateActivityPage({Key? key}) : super(key: key);

  @override
  _CreateActivityPageState createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final _activityService = ActivityService();
  final _notificationService = NotificationService();
  String _activityName = '';
  DateTime _activityDateTime = DateTime.now();
  String _activityLocation = '';
  String _activityTheme = '';

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
  }

  void _rollDiceForField(String field) {
    setState(() {
      switch (field) {
        case 'time':
          _activityDateTime = DateTime.now().add(Duration(days: Random().nextInt(7)));
          break;
        case 'location':
          final locations = ['海滩', '公园', '咖啡厅', '电影院', '游乐园'];
          _activityLocation = locations[Random().nextInt(locations.length)];
          break;
        case 'theme':
          final themes = ['海洋探险', '天空漫游', '海天盛筵', '星空派对', '海底世界'];
          _activityTheme = themes[Random().nextInt(themes.length)];
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建活动'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: '活动名称'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入活动名称';
                }
                return null;
              },
              onSaved: (value) => _activityName = value!,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '活动时间'),
                    controller: TextEditingController(text: _activityDateTime.toIso8601String()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入或随机生成活动时间';
                      }
                      return null;
                    },
                    onSaved: (value) => _activityDateTime = DateTime.parse(value!),
                  ),
                ),
                DiceWidget(onRoll: () => _rollDiceForField('time')),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '活动地点'),
                    controller: TextEditingController(text: _activityLocation),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入或随机生成活动地点';
                      }
                      return null;
                    },
                    onSaved: (value) => _activityLocation = value!,
                  ),
                ),
                DiceWidget(onRoll: () => _rollDiceForField('location')),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '活动主题'),
                    controller: TextEditingController(text: _activityTheme),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入或随机生成活动主题';
                      }
                      return null;
                    },
                    onSaved: (value) => _activityTheme = value!,
                  ),
                ),
                DiceWidget(onRoll: () => _rollDiceForField('theme')),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final activity = Activity(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _activityName,
                    time: _activityDateTime.toIso8601String(),
                    location: _activityLocation,
                    theme: _activityTheme,
                  );
                  await _activityService.saveCreatedActivity(activity);
                  await _notificationService.scheduleNotification(
                    '活动提醒',
                    '您的活动"$_activityName"将在1小时后开始',
                    _activityDateTime.subtract(Duration(hours: 1)),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('活动创建成功！已设置提醒。')),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('创建活动'),
            ),
          ],
        ),
      ),
    );
  }
}
