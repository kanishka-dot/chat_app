import 'dart:convert';

import 'package:chat_app/config/Repository.dart';
import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/models/Feedback.dart';
import 'package:chat_app/models/ProfileDetails.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/friend_request_page.dart';
import 'package:chat_app/screens/friends_list_page.dart';
import 'package:chat_app/screens/message_page.dart';
import 'package:chat_app/screens/partner_list.dart';
import 'package:chat_app/screens/user_account_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/config/color_palette.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_feedback/quick_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  final bool isReg;
  @override
  MainMenuState createState() => new MainMenuState(isReg: isReg);
  MainMenu({@required this.isReg});
}

class MainMenuState extends State<MainMenu> {
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Repository _repository = Repository();
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
    loadFCM();
    listenFCM();
    requestPermission();
    // getToken();
    loginUser = FirebaseAuth.instance.currentUser;
    if (isReg) {
      currentindex = 0;
    } else {
      currentindex = 0;
    }
    // getProfileImage();
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      print(token);
    });
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
        actions: isReg
            ? [
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
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.feedback,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('Admin Help')
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
                                  Text('Logout')
                                ],
                              ))
                        ])
              ]
            : [],
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
      case 2:
        showFeedbackDialog(context); //Account
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

  showFeedbackDialog(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Submit"),
      onPressed: () async {
        if (_textFieldController.toString().trim().isNotEmpty) {
          String _userString = await _repository.readData("user");
          UserModel _userObject = UserModel.fromJson(jsonDecode(_userString));
          service.saveFeedback(_userObject.userid, _userObject.username, 0,
              _textFieldController.text);
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "We will be in touch with you");
        }
        print(_textFieldController.text);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Admin Help"),
      content: TextField(
        onChanged: (value) {},
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Type your message"),
      ),
      actions: [okButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showFeedback(context) {
    showDialog(
      context: context,
      builder: (context) {
        return QuickFeedback(
          title: 'Admin Help',
          showTextBox: true,
          textBoxHint: 'Type your message',
          submitText: 'SUBMIT',
          onSubmitCallback: (feedback) async {
            var fb = Feedbacks.fromJson(feedback);
            if (fb.rating > 0) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              // ProfileDetails userProfile = await getUserDetails();
              service.saveFeedback(preferences.getString("id"),
                  preferences.getString("username"), fb.rating, fb.feedback);
              Fluttertoast.showToast(msg: "We will be in touch with you");
            }

            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
