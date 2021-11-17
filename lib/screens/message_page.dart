import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/conversation_page.dart';
import 'package:chat_app/widgets/SquareAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var loginUser = FirebaseAuth.instance.currentUser.uid;

class Messages extends StatelessWidget {
  TextEditingController messageTextControler = TextEditingController();

  Service service = Service();
  final auth = FirebaseAuth.instance;
  final messageStore = FirebaseFirestore.instance;

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

class ShowMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(loginUser)
          .collection('friends')
          .where("status", isEqualTo: 'accept')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            primary: true,
            itemBuilder: (context, i) {
              QueryDocumentSnapshot x = snapshot.data.docs[i];

              return ListTile(
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
                          builder: (context) =>
                              Conversation(x['userid'], x['username'])))
                },
              );
            });
      },
    );
  }
}
