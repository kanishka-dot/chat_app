import 'dart:io';
import 'package:chat_app/config/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  SharedPreferences preferences;
  TextEditingController nameTextEditorController;
  TextEditingController statusTextEditorController;
  String id = "";
  String nickname = "";
  String status = "";
  String photourl = "";
  File imgeFileAvatar;
  bool isLoading = false;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode statusFocusNode = FocusNode();
  Service service = Service();

  @override
  void initState() {
    super.initState();

    readDataFromLocal();
  }

  void readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();

    id = preferences.getString('id');
    nickname = preferences.getString('username');
    status = preferences.getString('text_status');
    photourl = preferences.getString('dpurl');

    nameTextEditorController = TextEditingController(text: nickname);
    statusTextEditorController = TextEditingController(text: status);
    setState(() {});
  }

  Future getImage() async {
    File image;
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);

    if (image != null) {
      setState(() {
        this.imgeFileAvatar = image;
        isLoading = true;
      });
    }
    uploadImageTofirestoreStorage();
  }

  Future uploadImageTofirestoreStorage() async {
    String mFilename = id;
    Reference storagereferance =
        FirebaseStorage.instance.ref().child(mFilename);
    UploadTask storageUploadTask = storagereferance.putFile(imgeFileAvatar);
    TaskSnapshot storageTaskSnapShot;
    storageUploadTask
        .whenComplete(() => {
              storagereferance.getDownloadURL().then(
                  (newDownlaodURL) => {
                        photourl = newDownlaodURL,
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(id)
                            .update({
                          "dpurl": photourl,
                          "text_status": status,
                          "username": nickname
                        }).then((value) async {
                          await preferences.setString("dpurl", photourl);
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(msg: "Update Successfully ");
                        })
                      }, onError: (errorMsg) {
                setState(() {
                  isLoading = false;
                });
                Fluttertoast.showToast(
                    msg: "Error occured in getting download url");
              })
            })
        .catchError((onError) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: onError.toString());
    });
  }

  updateData() {
    nameFocusNode.unfocus();
    statusFocusNode.unfocus();

    setState(() {
      isLoading = false;
    });
    FirebaseFirestore.instance.collection('users').doc(id).update({
      "dpurl": photourl,
      "text_status": status,
      "username": nickname
    }).then((value) async {
      await preferences.setString("dpurl", photourl);
      await preferences.setString("text_status", status);
      await preferences.setString("username", nickname);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Update Successfully ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (imgeFileAvatar == null)
                          ? (photourl != "")
                              ? Material(
                                  //display alreacy exsisiting profile image
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.lightBlueAccent),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photourl,
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(125.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 90,
                                  color: Colors.grey,
                                )
                          : Material(
                              child: Image.file(
                                imgeFileAvatar,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(125.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                      IconButton(
                        onPressed: getImage,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: 200.0,
                        icon: Icon(
                          Icons.camera_alt,
                          size: 100.0,
                          color: Colors.white54.withOpacity(0.3),
                        ),
                      )
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),
              // Input fields
              Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(1.0),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Container()),
                  Container(
                    child: Text(
                      'Profile Name: ',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Jhon",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: nameTextEditorController,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: nameFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  Container(
                    child: Text(
                      'About Me: ',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Traveler",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: statusTextEditorController,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: statusFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Container(
                child: FlatButton(
                  onPressed: () => {updateData()},
                  child: Text(
                    "Update",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Colors.lightBlueAccent,
                  highlightColor: Colors.grey,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 1.0),
              ),
              //logout
              Padding(
                padding: EdgeInsets.only(left: 50.0, right: 50.0),
                child: RaisedButton(
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                  onPressed: () => {service.loginOut(context)},
                  color: Colors.red,
                ),
              )
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        )
      ],
    );
  }
}
