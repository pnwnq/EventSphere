import 'package:flutter/material.dart';
import 'package:eventsphere/pages/home_page.dart';
import 'package:eventsphere/pages/create_activity_page.dart';
import 'package:eventsphere/pages/join_activity_page.dart';
import 'package:eventsphere/pages/activity_details_page.dart';
import 'package:eventsphere/pages/groups_page.dart';
import 'package:eventsphere/pages/group_details_page.dart';
import 'package:eventsphere/pages/login_page.dart';
import 'package:eventsphere/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventSphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/create': (context) => const CreateActivityPage(),
        '/join': (context) => const JoinActivityPage(),
        '/activity': (context) => const ActivityDetailsPage(),
        '/groups': (context) => const GroupsPage(),
        '/group': (context) => const GroupDetailsPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
