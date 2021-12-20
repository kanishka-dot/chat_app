import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/conversation_page.dart';
import 'package:chat_app/widgets/SquareAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => new _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController messageTextControler = TextEditingController();

  Service service = Service();
  final auth = FirebaseAuth.instance;
  final messageStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  reverse: false,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: ShowMessage(),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class ShowMessage extends StatefulWidget {
  @override
  _ShowMessage createState() => new _ShowMessage();
}

class _ShowMessage extends State<ShowMessage> {
  List<String> _listFriends = <String>[""];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getFriendsList();
  }

  var loginUser = FirebaseAuth.instance.currentUser.uid;
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
                child: Text('Lets Find Some friends'),
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
                      ),
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Conversation(
                                    x['userid'], x['username'], x['dpurl'])))
                      },
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
