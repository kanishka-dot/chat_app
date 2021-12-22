import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserAdditionlInfo extends StatefulWidget {
  @override
  _UserAdditionlInfoState createState() => _UserAdditionlInfoState();
}

class _UserAdditionlInfoState extends State<UserAdditionlInfo> {
  List<RadioModel> sampleData = new List<RadioModel>();
  bool isLoading = false;
  TextEditingController noChildTextEditorController;
  TextEditingController countryTextEditorController;
  TextEditingController residStatTextEditorController;
  TextEditingController residCityTextEditorController;
  TextEditingController citzneTextEditorController;
  TextEditingController jobTextEditorController;
  final FocusNode noChildFocusNode = FocusNode();
  final FocusNode countryFocusNode = FocusNode();
  final FocusNode residStatFocusNode = FocusNode();
  final FocusNode residCityFocusNode = FocusNode();
  final FocusNode citzneFocusNode = FocusNode();
  final FocusNode jobFocusNode = FocusNode();

  String noChild = "";
  String country = "";
  String residSta = "";
  String residCit = "";
  String citzne = "";
  String job = "";
  String _radioVal = "";
  int _radioSelected;

  @override
  void initState() {
    super.initState();
    sampleData.add(new RadioModel(false, 'A', 'April 18'));
    sampleData.add(new RadioModel(false, 'B', 'April 17'));
    sampleData.add(new RadioModel(false, 'C', 'April 16'));
    sampleData.add(new RadioModel(false, 'D', 'April 15'));
  }

  // updateData() {

  //   setState(() {
  //     isLoading = false;
  //   });

  //   try {
  //     if (nickname.trim().isEmpty) {
  //       throw ("Please enter a Name");
  //     }

  //     if (dob == null) {
  //       throw ("Date of birth is required");
  //     }

  //     if (_radioVal.isEmpty) {
  //       throw ("Gender is required");
  //     }

  //     FirebaseFirestore.instance.collection('users').doc(id).collection("moreinfo").doc(id).update({
  //       "dpurl": photourl,
  //       "text_status": status,
  //       "username": nickname,
  //       "dob": dob,
  //       "gender": _radioVal
  //     }).then((value) async {
  //       await preferences.setString("dpurl", photourl);
  //       await preferences.setString("text_status", status);
  //       await preferences.setString("username", nickname);
  //       await preferences.setInt("dob", dob.microsecondsSinceEpoch);
  //       await preferences.setString("gender", _radioVal);
  //       setState(() {
  //         isLoading = false;
  //       });
  //       Fluttertoast.showToast(msg: "Update Successfully ");
  //     });
  //   } catch (error) {
  //     Fluttertoast.showToast(msg: error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Additional Information"),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Input fields
                Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Martial Status: ',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      margin:
                          EdgeInsets.only(left: 10.0, bottom: 2.0, top: 1.0),
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
                                      groupValue: _radioSelected,
                                      activeColor: Colors.blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioSelected = value;
                                          _radioVal = 'unmaried';
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
                                      groupValue: _radioSelected,
                                      activeColor: Colors.blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioSelected = value;
                                          _radioVal = 'widower';
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
                                      groupValue: _radioSelected,
                                      activeColor: Colors.blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioSelected = value;
                                          _radioVal = 'divorced';
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
                                      groupValue: _radioSelected,
                                      activeColor: Colors.blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioSelected = value;
                                          _radioVal = 'separated';
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
                      child: Text(
                        'No of children: ',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
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
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText: "2",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          controller: noChildTextEditorController,
                          onChanged: (value) {
                            noChild = value;
                          },
                          focusNode: noChildFocusNode,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    Container(
                      child: Text(
                        'Country Living In: ',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
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
                              hintText: "Sri Lanka",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          controller: countryTextEditorController,
                          onChanged: (value) {
                            country = value;
                          },
                          focusNode: countryFocusNode,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    Container(
                      child: Text(
                        'Resident State: ',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
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
                              hintText: "Western",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          controller: residStatTextEditorController,
                          onChanged: (value) {
                            residSta = value;
                          },
                          focusNode: residStatFocusNode,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    Container(
                      child: Text(
                        'Resident City: ',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
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
                              hintText: "Colombo",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          controller: residCityTextEditorController,
                          onChanged: (value) {
                            residCit = value;
                          },
                          focusNode: residCityFocusNode,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    Container(
                      child: Text(
                        'Citizenship: ',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
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
                              hintText: "Sri Lankan",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          controller: citzneTextEditorController,
                          onChanged: (value) {
                            citzne = value;
                          },
                          focusNode: citzneFocusNode,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    Container(
                      child: Text(
                        'Job: ',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
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
                              hintText: "Accountant",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          controller: jobTextEditorController,
                          onChanged: (value) {
                            job = value;
                          },
                          focusNode: jobFocusNode,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),

                Container(
                  child: FlatButton(
                    onPressed: () => {},
                    child: Text(
                      "Update",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: Colors.blueGrey,
                    highlightColor: Colors.grey,
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  ),
                  margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
          )
        ],
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 50.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 10.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}
