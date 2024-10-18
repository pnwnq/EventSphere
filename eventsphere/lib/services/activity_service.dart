import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Activity {
  final String id;
  final String name;
  final String time;
  final String location;
  final String theme;
  final Map<String, bool> votes;
  final int participantsCount;

  Activity({
    required this.id,
    required this.name,
    required this.time,
    required this.location,
    required this.theme,
    Map<String, bool>? votes,
    this.participantsCount = 0,
  }) : votes = votes ?? {};

  Activity copyWith({
    String? name,
    String? time,
    String? location,
    String? theme,
    Map<String, bool>? votes,
    int? participantsCount,
  }) {
    return Activity(
      id: id,
      name: name ?? this.name,
      time: time ?? this.time,
      location: location ?? this.location,
      theme: theme ?? this.theme,
      votes: votes ?? this.votes,
      participantsCount: participantsCount ?? this.participantsCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'time': time,
    'location': location,
    'theme': theme,
    'votes': votes,
    'participantsCount': participantsCount,
  };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'],
    name: json['name'],
    time: json['time'],
    location: json['location'],
    theme: json['theme'],
    votes: Map<String, bool>.from(json['votes'] ?? {}),
    participantsCount: json['participantsCount'] ?? 0,
  );

  bool get isVotingComplete => votes.isNotEmpty && votes.values.every((v) => v);
}

class ActivityService {
  static const String _createdActivitiesKey = 'created_activities';
  static const String _joinedActivitiesKey = 'joined_activities';

  Future<void> saveCreatedActivity(Activity activity) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getCreatedActivities();
    activities.add(activity);
    await prefs.setString(_createdActivitiesKey, jsonEncode(activities.map((a) => a.toJson()).toList()));
  }

  Future<void> saveJoinedActivity(Activity activity) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getJoinedActivities();
    activities.add(activity);
    await prefs.setString(_joinedActivitiesKey, jsonEncode(activities.map((a) => a.toJson()).toList()));
  }

  Future<List<Activity>> getCreatedActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final activitiesJson = prefs.getString(_createdActivitiesKey);
    if (activitiesJson == null) return [];
    final activitiesList = jsonDecode(activitiesJson) as List;
    return activitiesList.map((json) => Activity.fromJson(json)).toList();
  }

  Future<List<Activity>> getJoinedActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final activitiesJson = prefs.getString(_joinedActivitiesKey);
    if (activitiesJson == null) return [];
    final activitiesList = jsonDecode(activitiesJson) as List;
    return activitiesList.map((json) => Activity.fromJson(json)).toList();
  }

  Future<Activity?> getActivityById(String id) async {
    final createdActivities = await getCreatedActivities();
    final joinedActivities = await getJoinedActivities();
    final allActivities = [...createdActivities, ...joinedActivities];
    try {
      return allActivities.firstWhere((activity) => activity.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> voteForActivity(String activityId, String userId, bool vote) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getCreatedActivities();
    final activityIndex = activities.indexWhere((a) => a.id == activityId);
    if (activityIndex != -1) {
      activities[activityIndex] = activities[activityIndex].copyWith(
        votes: {...activities[activityIndex].votes, userId: vote},
      );
      await prefs.setString(_createdActivitiesKey, jsonEncode(activities.map((a) => a.toJson()).toList()));
    }
  }

  Future<void> joinActivity(String activityId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getCreatedActivities();
    final activityIndex = activities.indexWhere((a) => a.id == activityId);
    if (activityIndex != -1) {
      activities[activityIndex] = activities[activityIndex].copyWith(
        participantsCount: activities[activityIndex].participantsCount + 1,
      );
      await prefs.setString(_createdActivitiesKey, jsonEncode(activities.map((a) => a.toJson()).toList()));
    }
  }

  Future<void> leaveActivity(String activityId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getCreatedActivities();
    final activityIndex = activities.indexWhere((a) => a.id == activityId);
    if (activityIndex != -1) {
      activities[activityIndex] = activities[activityIndex].copyWith(
        participantsCount: activities[activityIndex].participantsCount - 1,
      );
      await prefs.setString(_createdActivitiesKey, jsonEncode(activities.map((a) => a.toJson()).toList()));
    }
  }
}
