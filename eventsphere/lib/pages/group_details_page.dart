import 'package:flutter/material.dart';
import '../services/group_service.dart';
import '../services/activity_service.dart';
import '../services/user_service.dart';
import 'create_activity_page.dart';
import '../games/ocean_riddle_game.dart';
import 'group_members_page.dart';

class GroupDetailsPage extends StatefulWidget {
  final Group group;

  const GroupDetailsPage({Key? key, required this.group}) : super(key: key);

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  final GroupService _groupService = GroupService();
  final ActivityService _activityService = ActivityService();
  final UserService _userService = UserService();
  String _filterOption = 'all';
  String _sortOption = 'date';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupMembersPage(group: widget.group),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterAndSortOptions(),
          Expanded(
            child: FutureBuilder<List<Activity>>(
              future: _getGroupActivities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final activities = _filterAndSortActivities(snapshot.data ?? []);
                return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return _buildActivityCard(activity);
                  },
                );
              },
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildFilterAndSortOptions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownButton<String>(
            value: _filterOption,
            items: [
              DropdownMenuItem(value: 'all', child: Text('所有活动')),
              DropdownMenuItem(value: 'upcoming', child: Text('即将开始')),
              DropdownMenuItem(value: 'past', child: Text('已结束')),
            ],
            onChanged: (value) {
              setState(() {
                _filterOption = value!;
              });
            },
          ),
          DropdownButton<String>(
            value: _sortOption,
            items: [
              DropdownMenuItem(value: 'date', child: Text('按日期排序')),
              DropdownMenuItem(value: 'participants', child: Text('按参与人数排序')),
            ],
            onChanged: (value) {
              setState(() {
                _sortOption = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Card(
      child: ListTile(
        title: Text(activity.name),
        subtitle: Text('${activity.time} at ${activity.location}'),
        trailing: FutureBuilder<User?>(
          future: _userService.getCurrentUser(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) return SizedBox.shrink();
            final user = userSnapshot.data!;
            final hasVoted = activity.votes.containsKey(user.id);
            final vote = activity.votes[user.id] ?? false;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up, color: vote ? Colors.blue : Colors.grey),
                  onPressed: () => _vote(activity, user.id, true),
                ),
                IconButton(
                  icon: Icon(Icons.thumb_down, color: !vote && hasVoted ? Colors.red : Colors.grey),
                  onPressed: () => _vote(activity, user.id, false),
                ),
              ],
            );
          },
        ),
        onTap: () {
          // TODO: Navigate to activity details page
        },
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _createActivityForGroup,
          child: Text('创建群组活动'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OceanRiddleGame()),
            );
          },
          child: Text('玩海洋猜谜游戏'),
        ),
      ],
    );
  }

  Future<List<Activity>> _getGroupActivities() async {
    List<Activity> activities = [];
    for (String id in widget.group.activityIds) {
      Activity? activity = await _activityService.getActivityById(id);
      if (activity != null) {
        activities.add(activity);
      }
    }
    return activities;
  }

  List<Activity> _filterAndSortActivities(List<Activity> activities) {
    final now = DateTime.now();
    final filteredActivities = activities.where((activity) {
      final activityTime = DateTime.parse(activity.time);
      switch (_filterOption) {
        case 'upcoming':
          return activityTime.isAfter(now);
        case 'past':
          return activityTime.isBefore(now);
        default:
          return true;
      }
    }).toList();

    filteredActivities.sort((a, b) {
      switch (_sortOption) {
        case 'participants':
          return b.participantsCount.compareTo(a.participantsCount);
        default:
          return DateTime.parse(a.time).compareTo(DateTime.parse(b.time));
      }
    });

    return filteredActivities;
  }

  void _createActivityForGroup() async {
    final activity = await Navigator.push<Activity>(
      context,
      MaterialPageRoute(builder: (context) => CreateActivityPage()),
    );
    if (activity != null) {
      await _activityService.saveCreatedActivity(activity);
      await _groupService.addActivityToGroup(widget.group.id, activity.id);
      setState(() {});
    }
  }

  void _vote(Activity activity, String userId, bool vote) async {
    await _activityService.voteForActivity(activity.id, userId, vote);
    setState(() {});
  }
}
