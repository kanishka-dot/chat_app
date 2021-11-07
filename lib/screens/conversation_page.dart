import 'package:chat_app/widgets/message.dart';
import 'package:flutter/material.dart';

class Conversation extends StatelessWidget {
  var receiverid = "";
  var receiverName = "";

  Conversation(this.receiverid, this.receiverName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Message(receiverId: receiverid),
    );
  }

  AppBar buildAppBar() {
    print(receiverid);
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/person1.png'),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receiverName,
                style: TextStyle(fontSize: 16),
              ),
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
