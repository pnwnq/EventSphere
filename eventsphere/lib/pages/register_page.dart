import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/dice_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  String _username = '';

  void _generateRandomUsername() {
    final adjectives = ['快乐的', '可爱的', '聪明的', '勇敢的', '友善的'];
    final nouns = ['鲸鱼', '海豚', '海鸥', '章鱼', '水母'];
    final randomAdjective = adjectives[DateTime.now().millisecond % adjectives.length];
    final randomNoun = nouns[DateTime.now().second % nouns.length];
    setState(() {
      _username = '$randomAdjective$randomNoun';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('注册')),
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
                      decoration: InputDecoration(labelText: '用户名'),
                      controller: TextEditingController(text: _username),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入用户名或使用骰子生成';
                        }
                        return null;
                      },
                      onSaved: (value) => _username = value!,
                    ),
                  ),
                  DiceWidget(onRoll: _generateRandomUsername),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('注册'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('已有账号？返回登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _userService.registerUser(_username);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
