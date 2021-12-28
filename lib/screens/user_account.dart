import 'package:chat_app/screens/additional_infor_form.dart';
import 'package:chat_app/screens/user_account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAccountOptions extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccountOptions> {
  List<String> title = [
    "Basic Information",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
            itemCount: title.length,
            itemBuilder: (context, index) => Card(
                  elevation: 6,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(title[index]),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserAccount()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserAdditionlInfo()));
                      }
                    },
                  ),
                )),
      ),
    );
  }
}
