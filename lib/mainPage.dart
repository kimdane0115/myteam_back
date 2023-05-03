import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'data/user.dart';
import 'main/teamPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin{
  TabController? controller;
  // String? loginId;
  User? user;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // loginId = ModalRoute.of(context)!.settings.arguments as String?;
    user = ModalRoute.of(context)!.settings.arguments as User?;
    print("user : ${user?.id}, ${user?.teamName}, ${user?.adminFlag}");
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          TeamPage(loginId: user?.id, teamName: user?.teamName),
          TeamPage(loginId: user?.id!),
          TeamPage(loginId: user?.id!),
          TeamPage(loginId: user?.id!)
        ],
      ),
      bottomNavigationBar: TabBar(
        tabs: const <Tab>[
          Tab(
            icon: Icon(Icons.list),
          ),
          Tab(
            icon: Icon(Icons.history),
          ),
          Tab(
            icon: Icon(Icons.event),
          ),
          Tab(
            icon: Icon(Icons.settings),
          )
        ],
        labelColor: Colors.amber,
        indicatorColor: Colors.deepOrangeAccent,
        controller: controller,
      ));
  }
}
