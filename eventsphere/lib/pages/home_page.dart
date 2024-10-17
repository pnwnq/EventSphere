import 'package:flutter/material.dart';
import '../widgets/dice_widget.dart';
import 'create_activity_page.dart';
import 'join_activity_page.dart';
import 'groups_page.dart';
import '../services/activity_service.dart';
import '../services/user_service.dart';
import 'activity_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ActivityService _activityService = ActivityService();
  final UserService _userService = UserService();
  late TabController _tabController;
  User? _currentUser;
  String _searchQuery = '';
  String _filterOption = 'all';
  String _sortOption = 'date';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    final user = await _userService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('想和她一起玩'),
        actions: [
          if (_currentUser != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(_currentUser!.username)),
            ),
          IconButton(
            icon: Icon(Icons.group),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupsPage()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '已创建活动'),
            Tab(text: '已加入活动'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索活动...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Row(
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActivityList(_activityService.getCreatedActivities),
                _buildActivityList(_activityService.getJoinedActivities),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateActivityPage()),
              );
              setState(() {});
            },
            child: Icon(Icons.add),
            heroTag: 'createActivity',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JoinActivityPage()),
              );
              setState(() {});
            },
            child: Icon(Icons.group_add),
            heroTag: 'joinActivity',
          ),
          SizedBox(height: 16),
          DiceWidget(
            onRoll: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('骰子已滚动！')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(Future<List<Activity>> Function() getActivities) {
    return FutureBuilder<List<Activity>>(
      future: getActivities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final activities = snapshot.data ?? [];
        final filteredActivities = activities
            .where((activity) => activity.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .where((activity) {
              if (_filterOption == 'upcoming') {
                return DateTime.parse(activity.time).isAfter(DateTime.now());
              } else if (_filterOption == 'past') {
                return DateTime.parse(activity.time).isBefore(DateTime.now());
              }
              return true;
            })
            .toList();
        
        if (_sortOption == 'date') {
          filteredActivities.sort((a, b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)));
        } else if (_sortOption == 'participants') {
          filteredActivities.sort((a, b) => b.participantsCount.compareTo(a.participantsCount));
        }

        return filteredActivities.isEmpty
            ? Center(child: Text('暂无活动'))
            : ListView.builder(
                itemCount: filteredActivities.length,
                itemBuilder: (context, index) {
                  final activity = filteredActivities[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(activity.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('时间: ${activity.time}'),
                          Text('地点: ${activity.location}'),
                          Text('参与人数: ${activity.participantsCount}'),
                        ],
                      ),
                      trailing: Chip(
                        label: Text(activity.theme),
                        backgroundColor: Theme.of(context).primaryColorLight,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityDetailsPage(activity: activity),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}
