import 'package:chat_app/screens/conversation_page.dart';
import 'package:chat_app/screens/friend_request_page.dart';
import 'package:chat_app/screens/login_page.dart';
// import 'package:chat_app/screens/friends_list_page.dart';
import 'package:chat_app/screens/main_menu.dart';
import 'package:chat_app/screens/message_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/config/color_palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: Login());
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: Text('Hi'),
              leading: IconButton(
                onPressed: null,
                icon: Icon(Icons.menu),
              ),
              actions: [
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.more_vert),
                ),
              ],
              flexibleSpace: Image.asset(
                'assets/back.jpg',
                fit: BoxFit.cover,
              ),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.ac_unit)),
                  Tab(icon: Icon(Icons.mp)),
                  Tab(icon: Icon(Icons.museum))
                ],
              )),
          body: TabBarView(
            children: [
              Icon(Icons.ac_unit),
              Icon(Icons.mp),
              Icon(Icons.museum),
            ],
          ),
        ));
  }
}
