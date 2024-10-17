import 'package:flutter/material.dart';
import '../services/group_service.dart';
import '../services/user_service.dart';

class GroupMembersPage extends StatefulWidget {
  final Group group;

  const GroupMembersPage({Key? key, required this.group}) : super(key: key);

  @override
  _GroupMembersPageState createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  final GroupService _groupService = GroupService();
  final UserService _userService = UserService();
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _userService.getCurrentUser();
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('群组成员'),
      ),
      body: ListView.builder(
        itemCount: widget.group.members.length,
        itemBuilder: (context, index) {
          final member = widget.group.members[index];
          return ListTile(
            title: Text(member.username),
            leading: CircleAvatar(
              backgroundColor: Color(int.parse(member.colorCode.substring(1, 7), radix: 16) + 0xFF000000),
              child: Text(member.username[0]),
            ),
            trailing: _currentUser.id == widget.group.members[0].userId && _currentUser.id != member.userId
                ? IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () => _removeMember(member),
                  )
                : null,
          );
        },
      ),
    );
  }

  void _removeMember(GroupMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('移除成员'),
          content: Text('确定要移除 ${member.username} 吗？'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('确定'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _groupService.removeMemberFromGroup(widget.group.id, member.userId);
      setState(() {
        widget.group.members.remove(member);
      });
    }
  }
}
