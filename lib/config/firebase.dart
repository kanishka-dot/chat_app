import 'dart:convert';
import 'package:chat_app/config/Repository.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/main_menu.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Service {
  final auth = FirebaseAuth.instance; //firebase authenticatio
  final userStore = FirebaseFirestore.instance;
  final _codeController = TextEditingController();
  final Repository _repository = Repository();
  DocumentSnapshot snapshot;
  final storage = new FlutterSecureStorage();

  Future<void> saveLocally(String id, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(id, value);
  }

  Future<void> saveLocallyDob(String id, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(id, value);
  }

  Future<int> getReqCountParameter() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int reqcount = prefs.getInt('reqcount');

      if (reqcount == null) {
        var userData = await FirebaseFirestore.instance
            .collection("parameters")
            .doc("users")
            .get();

        reqcount = userData.get('request_count');
        prefs.setInt('reqcount', reqcount);
      }

      return reqcount;
    } catch (error) {
      return 0;
    }
  }

  Future<int> getCurrentUserRequest(String userid) async {
    try {
      int reqcount;

      var userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(userid)
          .get();

      reqcount = userData.get('request_count');

      return reqcount;
    } catch (error) {
      return 0;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
      String userid) async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(userid)
          .get();

      return userData;
    } catch (error) {
      return null;
    }
  }

  Future<String> getGender(String userid) async {
    try {
      String gender;

      var userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(userid)
          .get();

      gender = userData.get('gender');

      if (gender == 'male') {
        return 'female';
      } else {
        return 'male';
      }
    } catch (error) {
      return 'other';
    }
  }

  Future<void> saveUserDetails(userid) async {
    try {
      var _response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        return documentSnapshot.data();
      });

      UserModel _userData =
          UserModel.fromJson(_response as Map<String, dynamic>);
      _repository.addValue('user', jsonEncode(_userData.toJson()));

      // String _userString = await _repository.readData("user");
      // UserModel _userObject = UserModel.fromJson(jsonDecode(_userString));
    } catch (e) {
      print(e);
    }

   
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("id"));
    print(prefs.getString("username"));
  }

  getValue(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(id);
    return stringValue;
  }

  // create user function
  Future<int> createUser(String name, String phonenumber, String email,
      DateTime dob, String gender, String height, BuildContext context) async {
    try {
      EasyLoading.show(status: 'Please wait...');
      print("Print phone numer");
      print(phonenumber);
      await auth.verifyPhoneNumber(
          phoneNumber: "+94" + phonenumber,
          verificationCompleted: (AuthCredential credential) async {
            UserCredential result = await auth.signInWithCredential(credential);

            User user = result.user;

            if (user != null) {
              await isNewUser(
                  user.uid, name, phonenumber, email, dob, gender, height);
              EasyLoading.dismiss();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainMenu(
                          isReg: true,
                        )),
                (route) => false,
              );
            }
          },
          verificationFailed: (FirebaseAuthException exception) {
            Fluttertoast.showToast(
                msg: exception.toString(), gravity: ToastGravity.CENTER);
            EasyLoading.dismiss();
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            EasyLoading.dismiss();
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    title: Text("Please enter the OTP"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Confirm"),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {
                          EasyLoading.show(status: 'Please wait...');
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);

                          UserCredential result =
                              await auth.signInWithCredential(credential);

                          User user = result.user;

                          if (user != null) {
                            String userId = user.uid;
                            int result = await isNewUser(userId, name,
                                phonenumber, email, dob, gender, height);
                            if (result == 1) {
                              EasyLoading.dismiss();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainMenu(
                                          isReg: true,
                                        )),
                                (route) => false,
                              );
                            } else {
                              Navigator.of(context).pop();
                              EasyLoading.dismiss();
                              throw Exception("Error occured in creating user");
                            }
                          } else {
                            Navigator.of(context).pop();
                            EasyLoading.showError('Failed with Error');
                            print("Error");
                          }
                        },
                      )
                    ],
                  );
                });
          },
          codeAutoRetrievalTimeout: null,
          timeout: Duration(seconds: 100));
      return 1;
    } catch (e) {
      EasyLoading.dismiss();
      errorHandle(context, e);
      return 0;
    }
  }


  // logout user function
  void loginOut(context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await auth.signOut().whenComplete(() async {
        prefs.clear();
        await storage.delete(key: "token");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Register()),
          (route) => false,
        );
      });
    } catch (e) {
      errorHandle(context, e);
    }
  }

// Error Handleing
  void errorHandle(context, e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
          );
        });
  }

  Future<void> storeTokenAndDate(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<void> storeFCMToken(String userId) async {
    await FirebaseMessaging.instance.getToken().then((token) {
      print("my fcm toke--> " + token);
      userStore.collection("users").doc(userId).update({"fcm_token": token});
    });
  }

  Future<String> getToken() async {
    return await storage.read(key: "token");
  }

  Future<int> isNewUser(userId, String name, String phonenumber, String email,
      DateTime dob, String gender, String height) async {
    try {
      var result = await userStore.collection("users").doc(userId).get();
      if (!result.exists) {
        await userStore.collection("users").doc(userId).set({
          "email": email,
          "username": name,
          "dpurl": "",
          "userid": userId,
          "gender": gender,
          "dob": dob,
          "height": height,
          "age": "",
          "martial": "",
          "nochildrn": "",
          "country": "",
          "residstat": "",
          "residcity": "",
          "citzne": "",
          "job": "",
          "status": "active",
          "text_status": "",
          "cre_date": DateTime.now()
        });
        await saveUserDetails(userId);
        await storeTokenAndDate(userId);
        await storeFCMToken(userId);
        await userStore.collection("friends").doc(userId).set({});
      } else {
        await saveUserDetails(userId);
        await storeTokenAndDate(userId);
        await storeFCMToken(userId);
      }
      return 1;
    } catch (error) {
      return 0;
    }
  }

  Future<int> saveFeedback(
    String userID,
    String userName,
    int rate,
    String remark,
  ) async {
    try {
      await userStore
          .collection("feedbacks")
          .doc(DateTime.now().microsecondsSinceEpoch.toString())
          .set({
        "rating": rate,
        "remark": remark,
        "username": userName,
        "userid": userID,
        "date": DateTime.now()
      });

      return 1;
    } catch (error) {
      return 0;
    }
  }
}
