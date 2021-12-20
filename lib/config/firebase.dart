import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/main_menu.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Service {
  final auth = FirebaseAuth.instance; //firebase authenticatio
  final userStore = FirebaseFirestore.instance;
  final _codeController = TextEditingController();
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

  Future<void> saveUserDetails(userid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      saveLocally("id", userid);
      saveLocally("username", documentSnapshot.get('username'));
      saveLocally("status", documentSnapshot.get('status'));
      saveLocally("gender", documentSnapshot.get('gender'));
      Timestamp ts = documentSnapshot.get('dob');
      int timeInMilSec = ts.microsecondsSinceEpoch;
      saveLocallyDob("dob", timeInMilSec);
      saveLocally("dpurl", documentSnapshot.get('dpurl'));
      saveLocally("text_status", documentSnapshot.get('text_status'));
    });
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
  void createUser(String name, String phonenumber, String email, DateTime dob,
      String gender, BuildContext context) async {
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
              await isNewUser(user.uid, name, phonenumber, email, dob, gender);
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
                msg: "Invalid OTP Code", gravity: ToastGravity.CENTER);
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
                            await isNewUser(
                                userId, name, phonenumber, email, dob, gender);
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
          timeout: Duration(seconds: 80));
    } catch (e) {
      errorHandle(context, e);
    }
  }

  //  void createUser(context, email, password, username) async {
  //   try {
  //     await auth
  //         .createUserWithEmailAndPassword(email: email, password: password)
  //         .then((value) => {
  //               userStore.collection("users").doc(value.user.uid).set({
  //                 "email": email,
  //                 "username": username,
  //                 "dpurl": "",
  //                 "userid": value.user.uid,
  //                 "gender": "",
  //                 "age": "",
  //                 "status": "active",
  //                 "text_status": "",
  //                 "cre_date": DateTime.now()
  //               }),
  //               if (value.user.uid != "")
  //                 {
  //                   saveUserDetails(value.user.uid),
  //                   storeTokenAndDate(value.user.uid)
  //                 },
  //               userStore.collection("friends").doc(value.user.uid).set({}),
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => MainMenu()),
  //                 (route) => false,
  //               )
  //             });
  //   } catch (e) {
  //     errorHandle(context, e);
  //   }
  // }

  // login user function
  // void loginUser(context, phone) async {
  //   try {
  //    ConfirmationResult confirmationResult  = await auth.signInWithPhoneNumber(phone);

  //  confirmationResult.confirm(verificationCode)

  //           User user = result.user;
  //               if (value.user.uid != "") {saveUserDetails(value.user.uid)},
  //               storeTokenAndDate(value.user.uid),
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => MainMenu()),
  //                 (route) => false,
  //               )

  //   } catch (e) {
  //     errorHandle(context, e);
  //   }
  // }

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

  Future<String> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> isNewUser(userId, String name, String phonenumber, String email,
      DateTime dob, String gender) async {
    var result = await userStore.collection("users").doc(userId).get();
    if (!result.exists) {
      await userStore.collection("users").doc(userId).set({
        "email": email,
        "username": name,
        "dpurl": "",
        "userid": userId,
        "gender": gender,
        "dob": dob,
        "age": "",
        "status": "active",
        "text_status": "",
        "cre_date": DateTime.now()
      });
      await saveUserDetails(userId);
      await storeTokenAndDate(userId);
      await userStore.collection("friends").doc(userId).set({});
    } else {
      await saveUserDetails(userId);
      await storeTokenAndDate(userId);
    }
  }
}
