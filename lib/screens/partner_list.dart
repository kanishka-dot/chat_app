import 'package:chat_app/config/color_palette.dart';
import 'package:chat_app/screens/conversation_page.dart';
import 'package:chat_app/screens/profile_card.dart';
import 'package:chat_app/widgets/SquareAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PartnerList extends StatefulWidget {
  // const PartnerList({ Key? key }) : super(key: key);

  @override
  _PartnerListState createState() => _PartnerListState();
}

class _PartnerListState extends State<PartnerList> {
  final _fontSize = const TextStyle(fontSize: 15.0);
  List<String> _listFriends = <String>[""];
  Map<String, String> partnerRequestWay = Map();
  bool isLoading = true;
  var loginUser = FirebaseAuth.instance.currentUser.uid;

  void initState() {
    super.initState();
    getFriendsList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new CircularProgressIndicator()));
    } else {
      if (_listFriends.length == 0 || _listFriends == null) {
        _listFriends = [""];
      }
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("userid", whereIn: _listFriends)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.size <= 0) {
              return Center(
                child: Text('Lets Find Some Partners'),
              );
            }
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                primary: true,
                itemBuilder: (context, i) {
                  QueryDocumentSnapshot x = snapshot.data.docs[i];

                  return Column(children: <Widget>[
                    ListTile(
                      leading: new SquareAvatar(
                        x['dpurl'],
                      ),
                      title: Text(
                        x['username'],
                        style: _fontSize,
                      ),
                      subtitle: Text(
                        "Request:" +
                            partnerRequestWay[x['userid']] +
                            "\nAge:" +
                            x['age'] +
                            "\nHeight:" +
                            x['height'] +
                            " ft"
                                "\nCity:" +
                            x['residcity'],
                      ),
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileCard(x['userid'])))
                      },
                      trailing: ElevatedButton(
                        child: Text(
                          "Message",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Conversation(
                                      x['userid'], x['username'], x['dpurl'])))
                        },
                        style: ElevatedButton.styleFrom(
                          primary: sendrequestbutton, // backgr/ound
                        ),
                      ),
                    ),
                    Divider()
                  ]);
                });
          });
    }
  }

  void getFriendsList() async {
    await FirebaseFirestore.instance
        .collection("friends")
        .doc(loginUser)
        .collection('friends')
        .where("status", isEqualTo: 'accept')
        .snapshots()
        .forEach((element) {
      List<String> listFriends = <String>[];
      if (element.size > 0) {
        element.docs.forEach((users) {
          print(users["userid"]);
          partnerRequestWay[users["userid"]] = users["request"];
          listFriends.add(users["userid"]);
        });
      }
      setState(() {
        _listFriends = listFriends;
        isLoading = false;
      });
    });
  }
}
