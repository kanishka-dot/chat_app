import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/main_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Service {
  final auth = FirebaseAuth.instance; //firebase authenticatio

  // create user function
  void createUser(context, email, password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
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
