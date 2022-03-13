import 'package:chat_app/screens/profile_card.dart';
import 'package:chat_app/widgets/SquareAvatar.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:flutter/material.dart';

class Conversation extends StatelessWidget {
  var receiverid = "";
  var receiverName = "";
  var dpurl = "";

  Conversation(this.receiverid, this.receiverName, this.dpurl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Message(receiverId: receiverid),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    print(receiverid);
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          SquareAvatar(dpurl),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Text(
                  receiverName,
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileCard(receiverid)));
                },
              )
              // Text(
              //   "Active 2m ago",
              //   style: TextStyle(fontSize: 12),
              // )
            ],
          )
        ],
      ),
    );
  }
}
