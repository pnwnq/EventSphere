import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class GroupMember {
  final String userId;
  final String username;
  final String colorCode;

  GroupMember({required this.userId, required this.username, required this.colorCode});

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'colorCode': colorCode,
  };

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
    userId: json['userId'],
    username: json['username'],
    colorCode: json['colorCode'],
  );
}

class Group {
  final String id;
  final String name;
  final List<GroupMember> members;
  final List<String> activityIds;
  final String code;
  final DateTime codeExpiration;

  Group({
    required this.id,
    required this.name,
    required this.members,
    this.activityIds = const [],
    required this.code,
    required this.codeExpiration,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'members': members.map((member) => member.toJson()).toList(),
    'activityIds': activityIds,
    'code': code,
    'codeExpiration': codeExpiration.toIso8601String(),
  };

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json['id'],
    name: json['name'],
    members: (json['members'] as List).map((member) => GroupMember.fromJson(member)).toList(),
    activityIds: List<String>.from(json['activityIds'] ?? []),
    code: json['code'],
    codeExpiration: DateTime.parse(json['codeExpiration']),
  );
}

class GroupService {
  static const String _groupsKey = 'groups';

  Future<void> createGroup(String name, String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = await getGroups();
    final newGroup = Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      members: [GroupMember(userId: userId, username: username, colorCode: _generateRandomColor())],
    );
    groups.add(newGroup);
    await prefs.setString(_groupsKey, jsonEncode(groups.map((g) => g.toJson()).toList()));
  }

  Future<List<Group>> getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getString(_groupsKey);
    if (groupsJson == null) return [];
    final groupsList = jsonDecode(groupsJson) as List;
    return groupsList.map((json) => Group.fromJson(json)).toList();
  }

  Future<void> joinGroup(String groupId, String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = await getGroups();
    final groupIndex = groups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      groups[groupIndex].members.add(GroupMember(
        userId: userId,
        username: username,
        colorCode: _generateRandomColor(),
      ));
      await prefs.setString(_groupsKey, jsonEncode(groups.map((g) => g.toJson()).toList()));
    }
  }

  Future<void> addActivityToGroup(String groupId, String activityId) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = await getGroups();
    final groupIndex = groups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      groups[groupIndex].activityIds.add(activityId);
      await prefs.setString(_groupsKey, jsonEncode(groups.map((g) => g.toJson()).toList()));
    }
  }

  String _generateRandomColor() {
    return '#${Random().nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }

  Future<void> removeMemberFromGroup(String groupId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = await getGroups();
    final groupIndex = groups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      groups[groupIndex].members.removeWhere((member) => member.userId == userId);
      await prefs.setString(_groupsKey, jsonEncode(groups.map((g) => g.toJson()).toList()));
    }
  }

  Future<String> createGroupWithCode(String name, String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = await getGroups();
    final code = _generateGroupCode();
    final expirationTime = DateTime.now().add(Duration(hours: 24));
    final newGroup = Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      members: [GroupMember(userId: userId, username: username, colorCode: _generateRandomColor())],
      code: code,
      codeExpiration: expirationTime,
    );
    groups.add(newGroup);
    await prefs.setString(_groupsKey, jsonEncode(groups.map((g) => g.toJson()).toList()));
    return code;
  }

  Future<bool> joinGroupWithCode(String code, String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = await getGroups();
    final now = DateTime.now();
    final groupIndex = groups.indexWhere((g) => g.code == code && g.codeExpiration.isAfter(now));
    if (groupIndex != -1) {
      groups[groupIndex].members.add(GroupMember(
        userId: userId,
        username: username,
        colorCode: _generateRandomColor(),
      ));
      await prefs.setString(_groupsKey, jsonEncode(groups.map((g) => g.toJson()).toList()));
      return true;
    }
    return false;
  }

  String _generateGroupCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(6, (index) => chars[Random().nextInt(chars.length)]).join();
  }
}
