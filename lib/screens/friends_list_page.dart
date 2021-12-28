import 'package:chat_app/screens/profile_card.dart';
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
              return Column(
                  children: <Widget>[_buildRow(_listFriends[i]), Divider()]);
            });
      }
    }

    return new Scaffold(
      body: widget,
    );
  }

  Widget _buildRow(FriendsModel friendsModel) {
    return new ListTile(
      isThreeLine: true,
      leading: new SquareAvatar(
        friendsModel.profileImageUrl,
      ), //custom widget SquareAvatar
      title: new Text(
        friendsModel.name,
        style: _biggerFont,
      ),
      subtitle: Text(
        "Age:" +
            friendsModel.age +
            "\nCity:" +
            friendsModel.city +
            "\nHeight:" +
            friendsModel.height +
            " ft",
      ),
      trailing: isReg
          ? ElevatedButton(
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
            )
          : ElevatedButton(
              onPressed: null,
              child: const Text(
                'Send Request',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                primary: sendrequestbutton, // backgr/ound
              ),
            ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileCard(friendsModel)));
      },
    );
  }

  Future _getFriendList() async {
    try {
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

                String age = findAge(doc.get('dob')).toString();
                //void loged user
                if (doc["userid"] != FirebaseAuth.instance.currentUser.uid) {
                  FriendsModel friendsModel = new FriendsModel(
                    doc.data().toString().contains('username')
                        ? doc.get('username')
                        : '',
                    doc.data().toString().contains('dpurl')
                        ? doc.get('dpurl')
                        : '',
                    doc.data().toString().contains('userid')
                        ? doc.get('userid')
                        : '',
                    isPending,
                    age,
                    doc.data().toString().contains('text_status')
                        ? doc.get('text_status')
                        : '',
                    doc.data().toString().contains('gender')
                        ? doc.get('gender')
                        : '',
                    doc.data().toString().contains('height')
                        ? doc.get('height')
                        : '',
                    doc.data().toString().contains('residcity')
                        ? doc.get('residcity')
                        : '',
                  );
                  listFriends.add(friendsModel);
                }
              });

              setState(() {
                _listFriends = listFriends;
                _isProgressBarShown = false;
              });
            });
          });
    } catch (error) {
      setState(() {
        _listFriends = [];
        _isProgressBarShown = false;
      });
    }
  }

  Future _getAllUsersList() async {
    try {
      List<String> newUser = <String>[""];
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .forEach((querySnapshot) {
        List<FriendsModel> listFriends = <FriendsModel>[];
        bool isPending = false;

        querySnapshot.docs.forEach((doc) {
          // int age = currentyear - byear;

          // print(age);
          String age = findAge(doc.get('dob')).toString();

          isPending = true;
          FriendsModel friendsModel = new FriendsModel(
            doc.data().toString().contains('username')
                ? doc.get('username')
                : '',
            doc.data().toString().contains('dpurl') ? doc.get('dpurl') : '',
            doc.data().toString().contains('userid') ? doc.get('userid') : '',
            isPending,
            age,
            doc.data().toString().contains('text_status')
                ? doc.get('text_status')
                : '',
            doc.data().toString().contains('gender') ? doc.get('gender') : '',
            doc.data().toString().contains('height') ? doc.get('height') : '',
            doc.data().toString().contains('residcity')
                ? doc.get('residcity')
                : '',
          );
          listFriends.add(friendsModel);
        });

        setState(() {
          _listFriends = listFriends;
          _isProgressBarShown = false;
        });
      });
    } catch (error) {
      setState(() {
        _listFriends = [];
        _isProgressBarShown = false;
      });
    }
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

  int findAge(Timestamp dob) {
    try {
      int currentyear = DateTime.now().year;

      DateTime dattime = dob.toDate();
      int age = currentyear - dattime.year;

      return age;
    } catch (error) {
      return 0;
    }
  }
}
