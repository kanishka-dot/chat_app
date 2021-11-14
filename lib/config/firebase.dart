import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/main_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  final auth = FirebaseAuth.instance; //firebase authenticatio
  final userStore = FirebaseFirestore.instance;
  DocumentSnapshot snapshot;

  void saveLocally(String id, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(id, value);
  }

  void saveUserDetails(userid) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        saveLocally("id", userid);
        saveLocally("username", documentSnapshot.get('username'));
        saveLocally("status", documentSnapshot.get('status'));
        saveLocally("gender", documentSnapshot.get('gender'));
        saveLocally("dpurl", documentSnapshot.get('dpurl'));
        saveLocally("text_status", documentSnapshot.get('text_status'));
      }
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
  void createUser(context, email, password, username) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                userStore.collection("users").doc(value.user.uid).set({
                  "email": email,
                  "username": username,
                  "dpurl": "",
                  "userid": value.user.uid,
                  "gender": "",
                  "age": "",
                  "status": "active",
                  "text_status": "",
                  "cre_date": DateTime.now()
                }),
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()))
              });
    } catch (e) {
      errorHandle(context, e);
    }
  }

  // login user function
  void loginUser(context, email, password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                if (value.user.uid != "") {saveUserDetails(value.user.uid)},
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainMenu()))
              });
    } catch (e) {
      errorHandle(context, e);
    }
  }

  // logout user function
  void loginOut(context) async {
    try {
      await auth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
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
}
