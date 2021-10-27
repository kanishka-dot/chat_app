import 'package:chat_app/screens/friend_request_page.dart';
import 'package:chat_app/screens/friends_list_page.dart';
import 'package:chat_app/screens/message_page.dart';
import 'package:chat_app/screens/user_account_page.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/config/color_palette.dart';

class MainMenu extends StatefulWidget {
  MainMenu({Key key}) : super(key: key);

  @override
  FriendsState createState() => new FriendsState();
}

class FriendsState extends State<MainMenu> {
  int currentindex = 1;
  final screens = [
    UserAccount(),
    Messages(),
    FriendsPage(),
    FriendsRequest(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat App"),
      ),
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentindex,
        onTap: (index) => setState(() => {currentindex = index}),
        items: [
          BottomNavigationBarItem(
            backgroundColor: themecolor,
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            backgroundColor: themecolor,
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            backgroundColor: themecolor,
            icon: Icon(Icons.people_alt),
            label: 'Find Friends',
          ),
          BottomNavigationBarItem(
            backgroundColor: themecolor,
            icon: Icon(Icons.notifications),
            label: 'Request',
          )
        ],
      ),
    );
  }
}
