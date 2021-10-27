import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                          child: TextField(
                            enableSuggestions: true,
                            decoration: InputDecoration(
                                hintText: " Type a Message",
                                border: InputBorder.none),
                          ),
                        ),
                        Icon(
                          Icons.attach_file_outlined,
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
                  onTap: () => {print("object")},
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
