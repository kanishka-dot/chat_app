import 'package:chat_app/screens/friend_request_page.dart';
import 'package:chat_app/screens/friends_list_page.dart';
import 'package:chat_app/screens/message_page.dart';
import 'package:chat_app/screens/user_account.dart';
import 'package:chat_app/screens/user_account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/config/color_palette.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainMenu extends StatefulWidget {
  final bool isReg;
  @override
  MainMenuState createState() => new MainMenuState(isReg: isReg);
  MainMenu({@required this.isReg});
}

class MainMenuState extends State<MainMenu> {
  var loginUser;
  // SharedPreferences preferences;
  String photoUrl = "";
  int currentindex = 1;
  bool isReg;
  List<dynamic> screens = [];
  // List<String> _listFriend;
  MainMenuState({@required this.isReg}) {
    screens = [
      Messages(),

      FriendsPage(
        isReg: isReg,
      ),
      FriendsRequest(),
      // UserAccount(),
      UserAccountOptions()
    ];
  }

  @override
  void initState() {
    super.initState();
    loginUser = FirebaseAuth.instance.currentUser;
    if (isReg) {
      currentindex = 1;
    } else {
      currentindex = 1;
    }
    // getProfileImage();
  }

  // Future getProfileImage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String photourl = prefs.get('dpurl');
  //   setState(() {
  //     photoUrl = photourl;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat App"),
      ),
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentindex,
        onTap: (index) => setState(() => {
              if (isReg)
                {currentindex = index}
              else
                {
                  Fluttertoast.showToast(
                      msg: "Please Register to acces more features",
                      gravity: ToastGravity.CENTER)
                }
            }),
        items: [
          BottomNavigationBarItem(
            backgroundColor: bottomNavColor,
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            backgroundColor: bottomNavColor,
            icon: Icon(Icons.people_alt),
            label: 'Find Friends',
          ),
          BottomNavigationBarItem(
            backgroundColor: bottomNavColor,
            icon: Icon(Icons.notifications),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            backgroundColor: bottomNavColor,
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
