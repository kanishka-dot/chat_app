import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/message_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class Message extends StatefulWidget {
  final String receiverId;

  @override
  _MessageState createState() => _MessageState(receiverId: receiverId);

  Message({@required this.receiverId});
}

class _MessageState extends State<Message> {
  TextEditingController messageTextControler = TextEditingController();
  Service service = Service();
  final auth = FirebaseAuth.instance;
  final messageStore = FirebaseFirestore.instance;
  String receiverId;
  String id;

  String chatId;
  SharedPreferences preferances;

  _MessageState({@required this.receiverId});

  @override
  void initState() {
    super.initState();
    chatId = "";

    readLocal();
  }

  readLocal() async {
    preferances = await SharedPreferences.getInstance();
    id = preferances.getString("id") ?? "";

    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
    }

    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'chattingwith': receiverId});
    setState(() {});
  }

  createListMessage() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .doc(chatId)
          .collection(chatId)
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print("Ado data naaaa");
        } else {
          print(snapshot.data.docs);
        }
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
                    crossAxisAlignment: loginUser.uid == x['sent_by']
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: loginUser.uid == x['sent_by']
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
                  child: createListMessage(),
                ),
              ),
            ],
          ),
        ),
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
                        messageStore
                            .collection("messages")
                            .doc(chatId)
                            .collection(chatId)
                            .doc(DateTime.now()
                                .microsecondsSinceEpoch
                                .toString())
                            .set({
                          "message": messageTextControler.text.trim(),
                          "sent_by": loginUser.uid.toString(),
                          "received_by": receiverId,
                          "time": DateTime.now(),
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

// class ShowMessage extends StatelessWidget {
//   final String receiverid;
//   final String senderid;

//   ShowMessage({@required this.receiverid, @required this.senderid});

//   @override
//   _ShowMessageState createState() =>
//       _ShowMessageState(receiverid: receiverid, senderid: senderid);
// }

// class _ShowMessageState extends State<ShowMessage> {
//   String receiverid;
//   String senderid;
//   String chatId;
//   String id;
//   SharedPreferences preferances;
//   _ShowMessageState(
//       {Key key, @required this.receiverid, @required this.senderid});

//   initState() {
//     super.initState();

//     getChatId();
//   }

//   void getChatId() {
//     if (senderid.hashCode <= receiverid.hashCode) {
//       chatId = '$senderid-$receiverid';
//     } else {
//       chatId = '$receiverid-$senderid';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("messages")
//           .doc(chatId)
//           .collection(chatId)
//           .orderBy("time", descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           print("Ado data naaaa");
//         } else {
//           print(snapshot.data.docs);
//         }
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return ListView.builder(
//             physics: ScrollPhysics(),
//             reverse: true,
//             itemCount: snapshot.data.docs.length,
//             shrinkWrap: true,
//             primary: true,
//             itemBuilder: (context, i) {
//               QueryDocumentSnapshot x = snapshot.data.docs[i];
//               print('query--->$x');
//               print("Hiiiiiiiiiiii");
//               return ListTile(
//                 title: Column(
//                     crossAxisAlignment: loginUser.uid == x['sent_by']
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             color: loginUser.uid == x['sent_by']
//                                 ? Colors.blue.withOpacity(0.5)
//                                 : Colors.amber.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(12)),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                         child: Text(
//                           x['message'],
//                         ),
//                       )
//                     ]),
//               );
//             });
//       },
//     );
//   }
// }
