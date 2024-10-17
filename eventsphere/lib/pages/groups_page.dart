import 'package:flutter/material.dart';
import '../services/group_service.dart';
import '../services/user_service.dart';
import 'group_details_page.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final GroupService _groupService = GroupService();
  final UserService _userService = UserService();
  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final groups = await _groupService.getGroups();
    setState(() {
      _groups = groups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('群组'),
      ),
      body: ListView.builder(
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          final group = _groups[index];
          return ListTile(
            title: Text(group.name),
            subtitle: Text('成员数: ${group.members.length}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailsPage(group: group),
                ),
              ).then((_) => _loadGroups());
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _createNewGroup,
            child: Icon(Icons.add),
            heroTag: 'createGroup',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _joinGroup,
            child: Icon(Icons.group_add),
            heroTag: 'joinGroup',
          ),
        ],
      ),
    );
  }

  void _createNewGroup() async {
    final user = await _userService.getCurrentUser();
    if (user != null) {
      String? groupName = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          String name = '';
          return AlertDialog(
            title: Text('创建新群组'),
            content: TextField(
              onChanged: (value) => name = value,
              decoration: InputDecoration(hintText: "输入群组名称"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('创建'),
                onPressed: () => Navigator.of(context).pop(name),
              ),
            ],
          );
        },
      );

      if (groupName != null && groupName.isNotEmpty) {
        final code = await _groupService.createGroupWithCode(groupName, user.id, user.username);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('群组创建成功！邀请码: $code')),
        );
        _loadGroups();
      }
    }
  }

  void _joinGroup() async {
    final user = await _userService.getCurrentUser();
    if (user != null) {
      String? groupCode = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          String code = '';
          return AlertDialog(
            title: Text('加入群组'),
            content: TextField(
              onChanged: (value) => code = value,
              decoration: InputDecoration(hintText: "输入群组邀请码"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('加入'),
                onPressed: () => Navigator.of(context).pop(code),
              ),
            ],
          );
        },
      );

      if (groupCode != null && groupCode.isNotEmpty) {
        final success = await _groupService.joinGroupWithCode(groupCode, user.id, user.username);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('成功加入群组！')),
          );
          _loadGroups();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('加入群组失败。请检查邀请码是否正确或是否已过期。')),
          );
        }
      }
    }
  }
}
