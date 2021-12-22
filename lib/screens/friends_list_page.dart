import 'package:chat_app/widgets/SquareAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/FriendsModel.dart';
import 'package:chat_app/config/color_palette.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FriendsPage extends StatefulWidget {
  final bool isReg;
  @override
  FriendsState createState() => new FriendsState(isReg: isReg);
  FriendsPage({@required this.isReg});
}

class FriendsState extends State<FriendsPage> {
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 15.0);
  List<FriendsModel> _listFriends;
  final userStore = FirebaseFirestore.instance;
  bool isReg;
  // List<String> _listFriend;
  FriendsState({@required this.isReg});
  @override
  void initState() {
    super.initState();
    if (isReg) {
      _getFriendList();
    } else {
      _getAllUsersList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (_isProgressBarShown) {
      widget = new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new CircularProgressIndicator()));
    } else {
      if (_listFriends.length == 0 || _listFriends == null) {
        widget = new Center(child: new Text('Lets wait for some friends'));
      } else {
        widget = new ListView.builder(
            physics:
                BouncingScrollPhysics(), //animation when scrolling top  end and bottom end
            itemCount: _listFriends.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            itemBuilder: (context, i) {
              return _buildRow(_listFriends[i]);
            });
      }
    }

    return new Scaffold(
      body: widget,
    );
  }

  Widget _buildRow(FriendsModel friendsModel) {
    return new ListTile(
      leading: new SquareAvatar(
        friendsModel.profileImageUrl,
      ), //custom widget SquareAvatar
      title: new Text(
        friendsModel.name,
        style: _biggerFont,
      ),
      subtitle: Text(
        "Age:" + friendsModel.age,
      ),
      trailing: ElevatedButton(
        onPressed: friendsModel.isPending
            ? null
            : () => {sendRequest(friendsModel.userid)},
        child: friendsModel.isPending
            ? const Text(
                'Pending',
                style: TextStyle(color: Colors.white, fontSize: 12),
              )
            : const Text(
                'Send Request',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
        style: ElevatedButton.styleFrom(
          primary: sendrequestbutton, // backgr/ound
        ),
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  Future _getFriendList() async {
    var userid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('friends')
        .doc(userid)
        .collection('friends')
        .where('status', whereIn: ['accept', 'pending', 'sent'])
        .snapshots()
        .forEach((querySnapshot) {
          List<String> listFriend = <String>[];
          List<String> sentFriend = <String>[];
          if (querySnapshot.size > 0) {
            querySnapshot.docs.forEach((values) {
              var userid = values["userid"];
              if (values["status"] == 'sent') {
                print(userid);
                sentFriend.add(userid);
              } else {
                listFriend.add(userid); // get user friend list
              }
            });
          }

          List<String> newUser = <String>[""];
          FirebaseFirestore.instance
              .collection('users')
              .where('userid', // remove friends from find friends list
                  whereNotIn: (listFriend == null || listFriend.length == 0
                      ? newUser
                      : listFriend)) //if new user
              .snapshots()
              .forEach((querySnapshot) {
            List<FriendsModel> listFriends = <FriendsModel>[];
            bool isPending = false;

            querySnapshot.docs.forEach((doc) {
              if (sentFriend.contains(doc["userid"])) {
                isPending = true;
              } else {
                isPending = false;
              }
              //void loged user
              if (doc["userid"] != FirebaseAuth.instance.currentUser.uid) {
                FriendsModel friendsModel = new FriendsModel(doc["username"],
                    doc["dpurl"], doc["userid"], isPending, doc["age"]);
                listFriends.add(friendsModel);
              }
            });

            setState(() {
              _listFriends = listFriends;
              _isProgressBarShown = false;
            });
          });
          // print('Friendsssssssssssssss---->$listFriend');
          // setState(() {
          //   _listFriend = listFriend;
          //   _isProgressBarShown = false;
          // });
        });
  }

  Future _getAllUsersList() async {
    // FirebaseFirestore.instance
    //     .collection('friends')
    //     .snapshots()
    //     .forEach((querySnapshot) {
    //   List<String> listFriend = <String>[];
    //   List<String> sentFriend = <String>[];
    //   if (querySnapshot.size > 0) {
    //     querySnapshot.docs.forEach((values) {
    //       var userid = values["userid"];
    //       if (values["status"] == 'sent') {
    //         print(userid);
    //         sentFriend.add(userid);
    //       } else {
    //         listFriend.add(userid); // get user friend list
    //       }
    //     });
    //   }

    List<String> newUser = <String>[""];
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .forEach((querySnapshot) {
      List<FriendsModel> listFriends = <FriendsModel>[];
      bool isPending = false;

      querySnapshot.docs.forEach((doc) {
        isPending = true;
        //void loged user

        FriendsModel friendsModel = new FriendsModel(doc["username"],
            doc["dpurl"], doc["userid"], isPending, doc["age"]);
        listFriends.add(friendsModel);
      });

      setState(() {
        _listFriends = listFriends;
        _isProgressBarShown = false;
      });
    });
    // print('Friendsssssssssssssss---->$listFriend');
    // setState(() {
    //   _listFriend = listFriend;
    //   _isProgressBarShown = false;
    // });
    // });
  }

  sendRequest(String reciveruid) async {
    try {
      String name;
      String age;
      String gender;
      var userid = FirebaseAuth.instance.currentUser.uid;
      await userStore
          .collection("users")
          .doc(userid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        name = documentSnapshot.get('username');
        age = documentSnapshot.get('age');
        gender = documentSnapshot.get('gender');
      });
      if (name.isEmpty || gender.isEmpty) {
        throw ("Please update profile to find friends");
      }

      userStore
          .collection("friends")
          .doc(reciveruid)
          .collection('friends')
          .doc(userid)
          .set({
        'userid': userid,
        'status': 'pending',
        'create_date': DateTime.now()
      });
      userStore
          .collection("friends")
          .doc(userid)
          .collection('friends')
          .doc(reciveruid)
          .set({
        'userid': reciveruid,
        'status': 'sent',
        'create_date': DateTime.now()
      });
      Fluttertoast.showToast(msg: "Friend Request Sent");
    } catch (e) {
      Fluttertoast.showToast(msg: e);
    }
  }
}
