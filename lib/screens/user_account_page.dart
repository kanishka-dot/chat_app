import 'dart:convert';
import 'dart:io';
import 'package:chat_app/config/Repository.dart';
import 'package:chat_app/config/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/config/notificationApi.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  Service service = Service();
  final Repository _repository = Repository();
  NotificationApi notification = NotificationApi();
  UserModel _userObject;
  SharedPreferences preferences;
  TextEditingController nameTextEditorController;
  TextEditingController statusTextEditorController;
  TextEditingController heightEditingControler;
  //addition information
  TextEditingController noChildTextEditorController;
  TextEditingController countryTextEditorController;
  TextEditingController residStatTextEditorController;
  TextEditingController residCityTextEditorController;
  TextEditingController citzneTextEditorController;
  TextEditingController jobTextEditorController;
  //focus node
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode statusFocusNode = FocusNode();
  final FocusNode ageFocusNode = FocusNode();
  final FocusNode heightFocusNode = FocusNode();
  final FocusNode noChildFocusNode = FocusNode();
  final FocusNode countryFocusNode = FocusNode();
  final FocusNode residStatFocusNode = FocusNode();
  final FocusNode residCityFocusNode = FocusNode();
  final FocusNode citzneFocusNode = FocusNode();
  final FocusNode jobFocusNode = FocusNode();

  Timestamp ts;
  String id = "";
  String nickname = "";
  String status = "";
  String height = "";
  String photourl = "";
  DateTime dob;
  String _radioVal = "";
  String _MartialradioVal = "";
  //addition information
  String noChild = "";
  String country = "";
  String residSta = "";
  String residCit = "";
  String citzne = "";
  String job = "";
  int _radioSelected;
  int _MartialSelected;
  File imgeFileAvatar;
  bool isLoading = false;
  bool _childstate = false;
  File tempImage;
  int timestamp;

  var heightFormater =
      new MaskTextInputFormatter(mask: '#.##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    readDataFromLocal();
    // setState(() {
    //   int timestamp = preferences.getInt('dob');
    //   dob = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    // });
    // setState(() {
    //   dob = DateTime.now();
    // });
    //dob = DateTime.now();
  }

  void readDataFromLocal() async {
    try {
      String _userString = await _repository.readData("user");
      _userObject = UserModel.fromJson(jsonDecode(_userString));

      String token = await service.getToken();
      if (_userObject == null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(token)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          id = documentSnapshot.get("id");
          nickname = documentSnapshot.data().toString().contains('username')
              ? documentSnapshot.get('username')
              : '';
          status = documentSnapshot.data().toString().contains('text_status')
              ? documentSnapshot.get('text_status')
              : '';
          photourl = documentSnapshot.data().toString().contains('dpurl')
              ? documentSnapshot.get('dpurl')
              : '';
          height = documentSnapshot.data().toString().contains('height')
              ? documentSnapshot.get('height')
              : '';
          // ts = documentSnapshot.get('dob');
          Timestamp ts = documentSnapshot.data().toString().contains('dob')
              ? documentSnapshot.get('dob')
              : DateTime.now();

          timestamp = ts.microsecondsSinceEpoch;

          _radioVal = documentSnapshot.data().toString().contains('gender')
              ? documentSnapshot.get('gender')
              : '';

//additional info
          _MartialradioVal =
              documentSnapshot.data().toString().contains('martial')
                  ? documentSnapshot.get('martial')
                  : '';
          noChild = documentSnapshot.data().toString().contains('nochildrn')
              ? documentSnapshot.get('nochildrn')
              : '';
          country = documentSnapshot.data().toString().contains('country')
              ? documentSnapshot.get('country')
              : '';
          residSta = documentSnapshot.data().toString().contains('residstat')
              ? documentSnapshot.get('residstat')
              : '';
          residCit = documentSnapshot.data().toString().contains('residcity')
              ? documentSnapshot.get('residcity')
              : '';
          citzne = documentSnapshot.data().toString().contains('citzne')
              ? documentSnapshot.get('citzne')
              : '';
          job = documentSnapshot.data().toString().contains('job')
              ? documentSnapshot.get('job')
              : '';
        });
      } else {
        id = _userObject.userid;
        nickname = _userObject.username;
        status = _userObject.text_status;
        photourl = _userObject.dpurl;
        timestamp = _userObject.dob;
        _radioVal = _userObject.gender;
        height = _userObject.height;
//additional info preferances
        _MartialradioVal = _userObject.martial;
        noChild = _userObject.nochildrn;
        country = _userObject.country;
        residSta = _userObject.residstat;
        residCit = _userObject.residcity;
        citzne = _userObject.citzne;
        job = _userObject.job;
      }

      setState(() {
        if (_radioVal == "male") {
          _radioSelected = 1;
        } else if (_radioVal == "female") {
          _radioSelected = 2;
        }

        if (_MartialradioVal == "unmaried") {
          _MartialSelected = 1;
          _childstate = false;
          noChild = "";
        } else if (_MartialradioVal == "widower") {
          _MartialSelected = 2;
          _childstate = true;
        } else if (_MartialradioVal == "divorced") {
          _MartialSelected = 3;
          _childstate = true;
        } else if (_MartialradioVal == "separated") {
          _MartialSelected = 4;
          _childstate = true;
        }
        var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
        dob = date;

        nameTextEditorController = TextEditingController(text: nickname);
        statusTextEditorController = TextEditingController(text: status);
        heightEditingControler = TextEditingController(text: height);

        noChildTextEditorController = TextEditingController(text: noChild);
        countryTextEditorController = TextEditingController(text: country);
        residStatTextEditorController = TextEditingController(text: residSta);
        residCityTextEditorController = TextEditingController(text: residCit);
        citzneTextEditorController = TextEditingController(text: citzne);
        jobTextEditorController = TextEditingController(text: job);
        // dob = DateTime.fromMicrosecondsSinceEpoch(timestamp.toInt());
      });
    } catch (error) {
      Fluttertoast.showToast(msg: error);
    }
  }

  Future getImage() async {
    File image;
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);

    setState(() {
      tempImage = image;
    });

    _cropImage();
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper().cropImage(
        androidUiSettings: AndroidUiSettings(lockAspectRatio: false),
        sourcePath: tempImage.path);
    setState(() {
      if (cropped != null) {
        this.imgeFileAvatar = cropped;
        isLoading = true;
      }
    });

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
                          // "text_status": status,
                          // "username": nickname,
                          // "dob": dob,
                          // "gender": _radioVal
                        }).then((value) async {
                          // await preferences.setString("dpurl", photourl);
                           _userObject.dpurl = photourl;
                                _repository.addValue('user', jsonEncode(_userObject.toJson()));
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

    try {
      if (nickname.trim().isEmpty) {
        throw ("Please enter a Name");
      }

      if (dob == null) {
        throw ("Date of birth is required");
      }

      if (_radioVal.isEmpty) {
        throw ("Gender is required");
      }

      FirebaseFirestore.instance.collection('users').doc(_userObject.userid).update({
        "dpurl": photourl,
        "text_status": status,
        "username": nickname,
        "dob": dob,
        "gender": _radioVal,
        "height": height,
        "martial": _MartialradioVal,
        "nochildrn": noChild,
        "country": country,
        "residstat": residSta,
        "residcity": residCit,
        "citzne": citzne,
        "job": job,
      }).then((value) async {

        _userObject.username = nickname;
        _userObject.dpurl = photourl;
        _userObject.text_status = status;
        _userObject.dob = dob.microsecondsSinceEpoch;
        _userObject.gender = _radioVal;
        _userObject.height = height;
        _userObject.martial = _MartialradioVal;
        _userObject.nochildrn = noChild;
        _userObject.country = country;
        _userObject.residstat = residSta;
        _userObject.residcity = residCit;
        _userObject.citzne = citzne;
        _userObject.job = job;
        _repository.addValue('user', jsonEncode(_userObject.toJson()));

        // await preferences.setString("dpurl", photourl);
        // await preferences.setString("text_status", status);
        // await preferences.setString("username", nickname);
        // await preferences.setInt("dob", dob.microsecondsSinceEpoch);
        // await preferences.setString("gender", _radioVal);

        // await preferences.setString("height", heightFormater.getMaskedText());
        // await preferences.setString("martial", _MartialradioVal);
        // await preferences.setString("nochildrn", noChild);
        // await preferences.setString("country", country);
        // await preferences.setString("residstat", residSta);
        // await preferences.setString("residcity", residCit);
        // await preferences.setString("citzne", citzne);
        // await preferences.setString("job", job);

        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Successfully Updated");
      });
    } catch (error) {
      Fluttertoast.showToast(msg: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User Account Information"),
        ),
        body: Stack(
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
                                        placeholder: (context, url) =>
                                            Container(
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(125.0)),
                                      clipBehavior: Clip.hardEdge,
                                    )
                                  : Icon(
                                      Icons.account_circle,
                                      size: 200,
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
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 2.0, top: 1.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: Colors.lightBlueAccent),
                          child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: "Jhon",
                                contentPadding: EdgeInsets.all(5.0),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            controller: nameTextEditorController,
                            onChanged: (value) {
                              nickname = value;
                            },
                            focusNode: nameFocusNode,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Container(
                        child: Text(
                          'About Me: ',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: Colors.lightBlueAccent),
                          child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_box),
                                hintText: "I'm intrested to hike",
                                contentPadding: EdgeInsets.all(5.0),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            controller: statusTextEditorController,
                            onChanged: (value) {
                              status = value;
                            },
                            focusNode: statusFocusNode,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Container(
                        child: Text(
                          'Date of Birth: ',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: Colors.lightBlueAccent),
                          child: DateTimeField(
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.cake),
                                  contentPadding: EdgeInsets.all(5.0),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)))),
                              mode: DateTimeFieldPickerMode.date,
                              selectedDate: dob,
                              onDateSelected: (DateTime value) {
                                setState(() {
                                  dob = value;
                                });
                              }),
                        ),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),

                      // Container(
                      //   child: Theme(
                      //     data: Theme.of(context)
                      //         .copyWith(primaryColor: Colors.lightBlueAccent),
                      //     child: DateTimeFormField(
                      //       initialValue: dob,
                      //       initialDate: dob,
                      //       mode: DateTimeFieldPickerMode.date,
                      //       onDateSelected: (DateTime value) {
                      //         setState(() {
                      //           dob = value;
                      //         });
                      //       },
                      //       decoration: const InputDecoration(
                      //         hintText: 'Birthday',
                      //         border: OutlineInputBorder(
                      //             borderRadius:
                      //                 const BorderRadius.all(Radius.circular(10))),
                      //       ),
                      //     ),
                      //     // child: TextField(
                      //     //   keyboardType: TextInputType.number,
                      //     //   decoration: InputDecoration(
                      //     //     hintText: "24",
                      //     //     contentPadding: EdgeInsets.all(5.0),
                      //     //     hintStyle: TextStyle(color: Colors.grey),
                      //     //   ),
                      //     //   controller: ageTextEditorController,
                      //     //   onChanged: (value) {
                      //     //     age = value;
                      //     //   },
                      //     //   focusNode: ageFocusNode,
                      //     // ),
                      //   ),
                      //   margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      // ),
                      Container(
                        child: Text(
                          'Height: ',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: Colors.lightBlueAccent),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [heightFormater],
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.height),
                                hintText: "Height",
                                contentPadding: EdgeInsets.all(5.0),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            controller: heightEditingControler,
                            onChanged: (value) {
                              height = value;
                            },
                            focusNode: heightFocusNode,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Container(
                        child: Text(
                          'Gender: ',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),

                  Container(
                    child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Colors.lightBlueAccent),
                        child: Row(
                          children: [
                            Text('Male',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black)),
                            Radio(
                                value: 1,
                                groupValue: _radioSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = value;
                                    _radioVal = 'male';
                                  });
                                }),
                            Text('Female',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black)),
                            Radio(
                                value: 2,
                                groupValue: _radioSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = value;
                                    _radioVal = 'female';
                                  });
                                }),
                          ],
                        )),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  Container(
                    child: Text(
                      'Additional Information',
                      style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                  ),

//additional information

                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Martial Status: ',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 2.0, top: 1.0),
                  ),
                  Container(
                    child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Colors.lightBlueAccent),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: _MartialSelected,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        _MartialSelected = value;
                                        _MartialradioVal = 'unmaried';
                                        _childstate = false;
                                        noChild = "";
                                        noChildTextEditorController =
                                            TextEditingController(
                                                text: noChild);
                                      });
                                    }),
                                Text('Unmaried',
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 2,
                                    groupValue: _MartialSelected,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        _MartialSelected = value;
                                        _MartialradioVal = 'widower';
                                        _childstate = true;
                                      });
                                    }),
                                Text('Widower',
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 3,
                                    groupValue: _MartialSelected,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        _MartialSelected = value;
                                        _MartialradioVal = 'divorced';
                                        _childstate = true;
                                      });
                                    }),
                                Text('Divorced',
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 4,
                                    groupValue: _MartialSelected,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        _MartialSelected = value;
                                        _MartialradioVal = 'separated';
                                        _childstate = true;
                                      });
                                    }),
                                Text('Separated',
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black)),
                              ],
                            ),
                          ],
                        )),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'No of children: ',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 2.0, top: 1.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        enabled: _childstate,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.people),
                            hintText: "2",
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        controller: noChildTextEditorController,
                        onChanged: (value) {
                          noChild = value;
                        },
                        focusNode: noChildFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Country Living In: ',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.flag),
                            hintText: "Sri Lanka",
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        controller: countryTextEditorController,
                        onChanged: (value) {
                          country = value;
                        },
                        focusNode: countryFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  ),

                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Resident City: ',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.place),
                            hintText: "Colombo",
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        controller: residCityTextEditorController,
                        onChanged: (value) {
                          residCit = value;
                        },
                        focusNode: residCityFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  ),

                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Job: ',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.work),
                            hintText: "Accountant",
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        controller: jobTextEditorController,
                        onChanged: (value) {
                          job = value;
                        },
                        focusNode: jobFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
// end addition information
                  Container(
                    child: FlatButton(
                      onPressed: () => {updateData()},
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      color: const Color(0xFF7E0F4A),
                      highlightColor: Colors.grey,
                      splashColor: Colors.transparent,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                    margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                  ),

                  // Container(
                  //   child: FlatButton(
                  //     onPressed: () => {
                  //       NotificationApi.showNotification(
                  //           title: "Saraha",
                  //           body: "Hi Shara, how you do",
                  //           payload: "asr.as")
                  //     },
                  //     child: Text(
                  //       "Test",
                  //       style: TextStyle(fontSize: 16.0),
                  //     ),
                  //     color: Colors.blueGrey,
                  //     highlightColor: Colors.grey,
                  //     splashColor: Colors.transparent,
                  //     textColor: Colors.white,
                  //     padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius:
                  //             BorderRadius.all(Radius.circular(32.0))),
                  //   ),
                  //   margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                  // ),
                  //logout
                  // Padding(
                  //   padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  //   child: RaisedButton(
                  //     child: Text(
                  //       "Logout",
                  //       style: TextStyle(color: Colors.white, fontSize: 14.0),
                  //     ),
                  //     onPressed: () => {service.loginOut(context)},
                  //     color: Colors.red,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius:
                  //             BorderRadius.all(Radius.circular(32.0))),
                  //   ),
                  // )
                ],
              ),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
            )
          ],
        ));
  }
}
