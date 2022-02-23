import 'package:chat_app/models/FriendsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:chat_app/config/color_palette.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Row2Buttons extends StatelessWidget {
  var loginUser = FirebaseAuth.instance.currentUser.uid;
  final String buttonOneTitle;
  final String buttonTwoTitle;
  FriendsModel friendsModel;

  Row2Buttons(this.buttonOneTitle, this.buttonTwoTitle, this.friendsModel);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          // accept friend request
          margin: EdgeInsets.only(right: 4),
          child: ElevatedButton(
            onPressed: () {
              acceptFriendRequest(friendsModel.userid);
            },
            child: Text(
              buttonOneTitle,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(70, 1),
              primary: sendrequestbutton, // background
            ),
          ),
        ),
        Container(
          // reject friend request
          child: ElevatedButton(
            onPressed: () {
              rejectFriendRequest(friendsModel.userid);
            },
            child: Text(
              buttonTwoTitle,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(70, 1),
              primary: sendrequestbutton, // background
            ),
          ),
        ),
      ],
    );
  }

  void acceptFriendRequest(String senderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('friends')
          .doc(loginUser)
          .collection('friends')
          .doc(senderId)
          .update({"status": "accept"});
      await FirebaseFirestore.instance
          .collection('friends')
          .doc(senderId)
          .collection('friends')
          .doc(loginUser)
          .update({"status": "accept"});
      Fluttertoast.showToast(msg: "Friend Request Accepted");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error occured accepting friend request");
    }
  }

  void rejectFriendRequest(String senderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('friends')
          .doc(loginUser)
          .collection('friends')
          .doc(senderId)
          .delete();

      await FirebaseFirestore.instance
          .collection('friends')
          .doc(senderId)
          .collection('friends')
          .doc(loginUser)
          .delete();

      Fluttertoast.showToast(msg: "Friend Request Rejected");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error occured rejecting friend request");
    }
  }
}
