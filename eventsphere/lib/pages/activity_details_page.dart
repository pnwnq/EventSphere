import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/activity_service.dart';
import '../services/user_service.dart';
import '../services/comment_service.dart';
import '../widgets/dice_widget.dart';

class ActivityDetailsPage extends StatefulWidget {
  final Activity activity;

  const ActivityDetailsPage({Key? key, required this.activity}) : super(key: key);

  @override
  _ActivityDetailsPageState createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  late Activity _activity;
  final ActivityService _activityService = ActivityService();
  final UserService _userService = UserService();
  final CommentService _commentService = CommentService();
  bool _isParticipating = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activity = widget.activity;
    _checkParticipationStatus();
  }

  Future<void> _checkParticipationStatus() async {
    final user = await _userService.getCurrentUser();
    if (user != null) {
      setState(() {
        _isParticipating = _activity.votes.containsKey(user.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_activity.name),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareActivity,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('时间', _activity.time),
              _buildDetailRow('地点', _activity.location),
              _buildDetailRow('主题', _activity.theme),
              SizedBox(height: 20),
              Text('参与人数: ${_activity.participantsCount}'),
              SizedBox(height: 20),
              Text('投票情况', style: Theme.of(context).textTheme.titleLarge),
              _buildVotingSection(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isParticipating ? _leaveActivity : _joinActivity,
                child: Text(_isParticipating ? '退出活动' : '参与活动'),
              ),
              SizedBox(height: 20),
              Text('评论', style: Theme.of(context).textTheme.titleLarge),
              _buildCommentsList(),
              _buildCommentInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(text: '$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
          DiceWidget(onRoll: () {}),
        ],
      ),
    );
  }

  Widget _buildVotingSection() {
    return FutureBuilder<User?>(
      future: _userService.getCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final user = snapshot.data!;
        final hasVoted = _activity.votes.containsKey(user.id);
        final userVote = _activity.votes[user.id] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('你的投票: ${hasVoted ? (userVote ? '赞成' : '反对') : '未投票'}'),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _vote(user.id, true),
                  child: Text('赞成'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: userVote ? Colors.green : null,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _vote(user.id, false),
                  child: Text('反对'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasVoted && !userVote ? Colors.red : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('总投票: ${_activity.votes.length}'),
            Text('赞成: ${_activity.votes.values.where((v) => v).length}'),
            Text('反对: ${_activity.votes.values.where((v) => !v).length}'),
          ],
        );
      },
    );
  }

  Widget _buildCommentsList() {
    return FutureBuilder<List<Comment>>(
      future: _commentService.getComments(_activity.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final comments = snapshot.data ?? [];
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return ListTile(
              title: Text(comment.username),
              subtitle: Text(comment.content),
              trailing: Text(comment.createdAt.toString().substring(0, 16)),
            );
          },
        );
      },
    );
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: '添加评论...',
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _addComment,
        ),
      ],
    );
  }

  void _vote(String userId, bool vote) async {
    await _activityService.voteForActivity(_activity.id, userId, vote);
    setState(() {
      _activity.votes[userId] = vote;
    });
  }

  Future<void> _joinActivity() async {
    final user = await _userService.getCurrentUser();
    if (user != null) {
      await _activityService.joinActivity(_activity.id, user.id);
      setState(() {
        _activity = _activity.copyWith(participantsCount: _activity.participantsCount + 1);
        _isParticipating = true;
      });
    }
  }

  Future<void> _leaveActivity() async {
    final user = await _userService.getCurrentUser();
    if (user != null) {
      await _activityService.leaveActivity(_activity.id, user.id);
      setState(() {
        _activity = _activity.copyWith(participantsCount: _activity.participantsCount - 1);
        _isParticipating = false;
      });
    }
  }

  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      final user = await _userService.getCurrentUser();
      if (user != null) {
        final comment = Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          activityId: _activity.id,
          userId: user.id,
          username: user.username,
          content: _commentController.text,
          createdAt: DateTime.now(),
        );
        await _commentService.addComment(comment);
        _commentController.clear();
        setState(() {});
      }
    }
  }

  void _shareActivity() {
    final String shareText = '''
想和她一起玩：${_activity.name}
时：${_activity.time}
地点：${_activity.location}
主题：${_activity.theme}
参与人数：${_activity.participantsCount}
快来加入我们吧！
    ''';
    Share.share(shareText, subject: '邀请你参加活动：${_activity.name}');
  }
}
