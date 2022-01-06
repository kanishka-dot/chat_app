import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/friend_request_page.dart';
import 'package:chat_app/screens/friends_list_page.dart';
import 'package:chat_app/screens/message_page.dart';
import 'package:chat_app/screens/partner_list.dart';
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
  Service service = Service();
  var loginUser;

  // SharedPreferences preferences;
  String photoUrl = "";
  int currentindex = 0;
  bool isReg;
  List<dynamic> screens = [];
  // List<String> _listFriend;
  MainMenuState({@required this.isReg}) {
    screens = [
      FriendsPage(
        isReg: isReg,
      ),
      Messages(),
      FriendsRequest(),
      PartnerList(),

      // UserAccountOptions()
    ];
  }

  @override
  void initState() {
    super.initState();
    loginUser = FirebaseAuth.instance.currentUser;
    if (isReg) {
      currentindex = 0;
    } else {
      currentindex = 0;
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
        title: new Text("Love Me"),
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Account')
                          ],
                        )),
                    PopupMenuDivider(),
                    PopupMenuItem(
                        textStyle: TextStyle(color: Colors.red),
                        value: 0,
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Log Out')
                          ],
                        ))
                  ])
        ],
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
            icon: Icon(Icons.people_alt),
            label: 'Find Partner',
          ),
          BottomNavigationBarItem(
            backgroundColor: bottomNavColor,
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            backgroundColor: bottomNavColor,
            icon: Icon(Icons.notifications),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            backgroundColor: bottomNavColor,
            icon: Icon(Icons.group),
            label: 'Partner List',
          ),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        showAlertDialog(context); //logout
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserAccount())); //Account
        break;
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        service.loginOut(context);
      },
    );

    Widget cancel = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure to logout?"),
      actions: [okButton, cancel],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
