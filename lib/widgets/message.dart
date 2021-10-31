import 'dart:ffi';

import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/message_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class Message extends StatelessWidget {
  TextEditingController messageTextControler = TextEditingController();
  Service service = Service();
  final auth = FirebaseAuth.instance;
  final messageStore = FirebaseFirestore.instance;
  var receiverId;

  Message(this.receiverId);

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
                physics: ScrollPhysics(),
                reverse: false,
                child: Container(
                  height: MediaQuery.of(context).size.height - 150,
                  child: ShowMessage(receiverId),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                              controller: messageTextControler,
                              enableSuggestions: true,
                              decoration: InputDecoration(
                                  hintText: "Type a Message",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.image,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: Container(
                    height: 47,
                    width: 47,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blueGrey),
                    child: Icon(
                      Icons.send,
                      size: 33,
                    ),
                  ),
                  onTap: () => {
                    if (messageTextControler.text.trim().isNotEmpty)
                      {
                        messageStore.collection("messages").doc().set({
                          "message": messageTextControler.text.trim(),
                          "sent_by": loginUser.email.toString(),
                          "time": DateTime.now(),
                          "user": [loginUser.email.toString(), receiverId]
                        })
                      },
                    if (messageTextControler.text.isNotEmpty)
                      {messageTextControler.clear()}
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ShowMessage extends StatelessWidget {
  String receiverid;

  ShowMessage(this.receiverid);

  @override
  Widget build(BuildContext context) {
    // result = result.where('sender_id', isEqualTo: loginUser.email);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            physics: ScrollPhysics(),
            reverse: true,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            primary: true,
            itemBuilder: (context, i) {
              QueryDocumentSnapshot x = snapshot.data.docs[i];
              return ListTile(
                title: Column(
                    crossAxisAlignment: loginUser.email == x['sent_by']
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: loginUser.email == x['sent_by']
                                ? Colors.blue.withOpacity(0.5)
                                : Colors.amber.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          x['message'],
                        ),
                      )
                    ]),
              );
            });
      },
    );
  }
}
