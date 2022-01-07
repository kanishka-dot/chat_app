import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/FriendsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileCard extends StatefulWidget {
  final String userid;

  ProfileCard(this.userid);
  @override
  State<ProfileCard> createState() => _ProfileCardState(this.userid);
}

class _ProfileCardState extends State<ProfileCard> {
  String profileurl = "";

  String name = "";

  String about = "";

  String age = "";

  String gender = "";

  String city = "";

  String height = "";

  _ProfileCardState(String userid) {
    getUserData(userid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                // decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [Colors.blueGrey, Colors.blue])),
                child: Container(
              width: double.infinity,
              height: 350.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: profileurl.contains("https")
                      ? CachedNetworkImageProvider(
                          profileurl,
                        )
                      : AssetImage('assets/person1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //   CircleAvatar(
                    //     backgroundImage: profileurl.contains("https")
                    //         ? NetworkImage(profileurl)
                    //         : AssetImage('assets/person1.png'),
                    //     radius: 60.0,
                    //   ),
                    //   SizedBox(
                    //     height: 10.0,
                    //   ),
                    //   Text(
                    //     name,
                    //     style: TextStyle(
                    //       fontSize: 22.0,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    //   SizedBox(
                    //     height: 10.0,
                    //   ),
                    //   // Container(
                    //   //   width: 250.00,
                    //   //   child: RaisedButton(
                    //   //       disabledColor: Colors.green,
                    //   //       onPressed: isReg ? sendRequest : showRegNotfy,
                    //   //       shape: RoundedRectangleBorder(
                    //   //           borderRadius: BorderRadius.circular(80.0)),
                    //   //       elevation: 0.0,
                    //   //       padding: EdgeInsets.all(0.0),
                    //   //       child: Ink(
                    //   //         decoration: BoxDecoration(
                    //   //           gradient: LinearGradient(
                    //   //               begin: Alignment.centerRight,
                    //   //               end: Alignment.centerLeft,
                    //   //               colors: [Colors.blue, Colors.blue]),
                    //   //           borderRadius: BorderRadius.circular(30.0),
                    //   //         ),
                    //   //         child: Container(
                    //   //           constraints: BoxConstraints(
                    //   //               maxWidth: 300.0, minHeight: 50.0),
                    //   //           alignment: Alignment.center,
                    //   //           child: Text(
                    //   //             "Send Request",
                    //   //             style: TextStyle(
                    //   //                 color: Colors.white,
                    //   //                 fontSize: 20.0,
                    //   //                 fontWeight: FontWeight.w300),
                    //   //           ),
                    //   //         ),
                    //   //       )),
                    //   // ),
                  ],
                ),
              ),
            )),
          ),
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text(
                  //   "Info:",
                  //   style: TextStyle(
                  //       color: Colors.redAccent,
                  //       fontStyle: FontStyle.normal,
                  //       fontSize: 28.0),
                  // ),
                  // SizedBox(
                  //   height: 10.0,
                  // ),

                  Text(
                    'About Me',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),

                  Text(
                    about,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Age',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),

                  Text(
                    age,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),

                  Text(
                    gender,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'City',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),

                  Text(
                    city,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Height',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),

                  Text(
                    height + " ft",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  void getUserData(String userid) async {
    var userData =
        await FirebaseFirestore.instance.collection("users").doc(userid).get();
    setState(() {
      profileurl = userData['dpurl'];
      name = userData['username'];
      about = userData['text_status'];
      age = userData['age'];
      gender = userData['gender'];
      city = userData['residcity'];
      height = userData['height'];
    });
  }
}
