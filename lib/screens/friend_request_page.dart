import 'package:chat_app/widgets/Row2Buttons.dart';
import 'package:chat_app/widgets/SquareAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/FriendsModel.dart';

var loginUser = FirebaseAuth.instance.currentUser.uid;

class FriendsRequest extends StatefulWidget {
  FriendsRequest({Key key}) : super(key: key);

  @override
  FriendsState createState() => new FriendsState();
}

class FriendsState extends State<FriendsRequest> {
  bool _isProgressBarShown = true;
  final _fontSize = const TextStyle(fontSize: 13.0);
  List<FriendsModel> _listFriends;

  @override
  void initState() {
    super.initState();
    _getFriendReqList();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (_isProgressBarShown) {
      widget = new Center(child: new Text("No Friend Request"));
    } else {
      widget = new ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _listFriends.length,
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          itemBuilder: _listFriends.length == 0 || _listFriends == null
              ? _noFriendRequest()
              : (context, i) {
                  // if (i.isOdd) return new Divider();
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
          friendsModel.profileImageUrl), //custom widget SquareAvatar
      title: new Text(
        friendsModel.name,
        style: _fontSize,
      ),
      trailing: Row2Buttons("Add", "Reject"),
      onTap: () {
        setState(() {});
      },
    );
  }

  Widget _noFriendRequest() {
    return new Container(
      child: Center(
        child: Text("No Friend Request yet"),
      ),
    );
  }

  Future _getFriendReqList() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginUser)
        .collection('friends')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .forEach((querySnapshot) {
      List<String> listFriend = <String>[];
      querySnapshot.docs.forEach((values) {
        var userid = values["userid"];

        listFriend.add(userid);
      });
      List<String> newUser = <String>[""];
      FirebaseFirestore.instance
          .collection('users')
          .where('userid',
              whereIn: (listFriend == null || listFriend.length == 0
                  ? newUser
                  : listFriend)) // remove friends from find friends list
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
    });
    // print('Friendsssssssssssssss---->$listFriend');
    // setState(() {
    //   _listFriend = listFriend;
    //   _isProgressBarShown = false;
    // });
  }
}
