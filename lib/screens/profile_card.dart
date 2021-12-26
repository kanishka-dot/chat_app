import 'package:chat_app/models/FriendsModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileCard extends StatelessWidget {
  String profileurl = "";
  String name = "";
  String about = "";
  String age = "";
  String gender = "";
  String city = "";
  String height = "";

  ProfileCard(FriendsModel friendsModel) {
    profileurl = friendsModel.profileImageUrl;
    name = friendsModel.name;
    about = friendsModel.about;
    age = friendsModel.age;
    gender = friendsModel.gender;
    city = friendsModel.city;
    height = friendsModel.height;
  }

  // bool isReg = false;
  // bool isRequestSent = false;

  // void sendRequest() {
  //   Fluttertoast.showToast(msg: "Freind Request Sent");
  // }

  // void showRegNotfy() {
  //   Fluttertoast.showToast(msg: "Please Register ");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blueGrey, Colors.blue])),
              child: Container(
                width: double.infinity,
                height: 350.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: profileurl.contains("https")
                            ? NetworkImage(profileurl)
                            : AssetImage('assets/person1.png'),
                        radius: 60.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Container(
                      //   width: 250.00,
                      //   child: RaisedButton(
                      //       disabledColor: Colors.green,
                      //       onPressed: isReg ? sendRequest : showRegNotfy,
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(80.0)),
                      //       elevation: 0.0,
                      //       padding: EdgeInsets.all(0.0),
                      //       child: Ink(
                      //         decoration: BoxDecoration(
                      //           gradient: LinearGradient(
                      //               begin: Alignment.centerRight,
                      //               end: Alignment.centerLeft,
                      //               colors: [Colors.blue, Colors.blue]),
                      //           borderRadius: BorderRadius.circular(30.0),
                      //         ),
                      //         child: Container(
                      //           constraints: BoxConstraints(
                      //               maxWidth: 300.0, minHeight: 50.0),
                      //           alignment: Alignment.center,
                      //           child: Text(
                      //             "Send Request",
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 20.0,
                      //                 fontWeight: FontWeight.w300),
                      //           ),
                      //         ),
                      //       )),
                      // ),
                    ],
                  ),
                ),
              )),
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Center(
                    child: Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      about,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      'Age',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '25',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      gender,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      'City',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      city,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      'Height',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      height + " ft",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
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
}
