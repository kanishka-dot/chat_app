import 'package:flutter/material.dart';
import 'package:chat_app/config/color_palette.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                margin:
                    EdgeInsets.only(bottom: 30, left: 30, top: 50, right: 30),
                height: 300,
                width: 350,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Social Network',
                        style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                      ),
                    ),
                    Divider(
                      color: lienColor,
                      endIndent: 250,
                      indent: 16,
                      thickness: 1,
                    ),
                    ListTile(
                      leading: Icon(Icons.people_alt_rounded),
                      title: Text('Friends'),
                      onTap: () {},
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                height: 280,
                width: 350,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'User Profile',
                        style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                      ),
                    ),
                    Divider(
                      color: lienColor,
                      endIndent: 250,
                      indent: 16,
                      thickness: 1,
                    ),
                    ListTile(
                      leading: Icon(Icons.mode_edit),
                      title: Text('Edit Profile'),
                      onTap: () {},
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
