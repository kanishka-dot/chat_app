import 'package:chat_app/widgets/SquareAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/FriendsModel.dart';
import 'package:chat_app/config/color_palette.dart';
import 'package:fluttertoast/fluttertoast.dart';

var loginUser = FirebaseAuth.instance.currentUser.uid;

class FriendsPage extends StatefulWidget {
  FriendsPage({Key key}) : super(key: key);

  @override
  FriendsState createState() => new FriendsState();
}

class FriendsState extends State<FriendsPage> {
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 13.0);
  List<FriendsModel> _listFriends;
  final userStore = FirebaseFirestore.instance;
  // List<String> _listFriend;

  @override
  void initState() {
    super.initState();
    _getFriendList();
    // _fetchFriendsList();
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
      trailing: ElevatedButton(
        onPressed: sendRequest(friendsModel.userid),
        child: const Text(
          'Send Request',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          primary: sendrequestbutton, // background
        ),
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  // Future _fetchFriendsList() async {
  //   _isProgressBarShown = true;

  //   await _getFriendList().then((value) {
  //     print('Friends----->$_listFriend');
  //   });
  //   // final friends = await _getFriendList();

  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .where('userid', whereNotIn: _listFriend)
  //       .snapshots()
  //       .forEach((querySnapshot) {
  //     List<FriendsModel> listFriends = <FriendsModel>[];

  //     querySnapshot.docs.forEach((doc) {
  //       if (doc["userid"] != loginUser) {
  //         FriendsModel friendsModel =
  //             new FriendsModel(doc["username"], doc["dpurl"]);
  //         listFriends.add(friendsModel);
  //       }
  //     });

  //     setState(() {
  //       _listFriends = listFriends;
  //       _isProgressBarShown = false;
  //     });
  //   });
  // }

  Future _getFriendList() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginUser)
        .collection('friends')
        .where('status', isEqualTo: 'accept')
        .snapshots()
        .forEach((querySnapshot) {
      List<String> listFriend = <String>[];
      querySnapshot.docs.forEach((values) {
        var userid = values["userid"];

        listFriend.add(userid); // get user friend list
      });

      FirebaseFirestore.instance
          .collection('users')
          .where('userid',
              whereNotIn: listFriend) // remove friends from find friends list
          .snapshots()
          .forEach((querySnapshot) {
        List<FriendsModel> listFriends = <FriendsModel>[];

        querySnapshot.docs.forEach((doc) {
          if (doc["userid"] != loginUser) {
            FriendsModel friendsModel =
                new FriendsModel(doc["username"], doc["dpurl"], doc["userid"]);
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

  sendRequest(String uid) {
    try {
      userStore
          .collection("users")
          .doc(uid)
          .collection('friends')
          .doc(loginUser)
          .set({'status': 'pending', 'create_date': DateTime.now()});
      Fluttertoast.showToast(msg: "Friend Request Sent");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Friend Request unable to send");
    }
  }
}
