import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Comment {
  final String id;
  final String activityId;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'activityId': activityId,
    'userId': userId,
    'username': username,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'],
    activityId: json['activityId'],
    userId: json['userId'],
    username: json['username'],
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class CommentService {
  static const String _commentsKey = 'comments';

  Future<void> addComment(Comment comment) async {
    final prefs = await SharedPreferences.getInstance();
    final comments = await getComments(comment.activityId);
    comments.add(comment);
    await prefs.setString(_commentsKey, jsonEncode(comments.map((c) => c.toJson()).toList()));
  }

  Future<List<Comment>> getComments(String activityId) async {
    final prefs = await SharedPreferences.getInstance();
    final commentsJson = prefs.getString(_commentsKey);
    if (commentsJson == null) return [];
    final commentsList = jsonDecode(commentsJson) as List;
    return commentsList
        .map((json) => Comment.fromJson(json))
        .where((comment) => comment.activityId == activityId)
        .toList();
  }
}
