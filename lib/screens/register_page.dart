import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/main_menu.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  TextEditingController emailEditingControler = TextEditingController();
  TextEditingController userNameEditingControler = TextEditingController();
  TextEditingController mobileEditingControler = TextEditingController();
  TextEditingController heightEditingControler = TextEditingController();
  String _radioVal = "";
  static final validateName = RegExp(r'^[a-zA-Z0-9\s]+$', caseSensitive: false);
  static final validateEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  DateTime selectedDate;
  int _radioSelected;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '## ## #####', filter: {"#": RegExp(r'[0-9]')});
  var heightFormater =
      new MaskTextInputFormatter(mask: '#.##', filter: {"#": RegExp(r'[0-9]')});
  // var maskFormatter = new MaskTextInputFormatter(
  //     mask: '### ### ####', filter: {"#": RegExp(r'[0-9]')});
  Service service = Service();

  bool validateFields() {
    try {
      if (userNameEditingControler.text.trim().isEmpty) {
        throw ("Please enter a Name");
      } else if (!validateName.hasMatch(userNameEditingControler.text)) {
        throw ("use only Letter number and underscores for name");
      } else if (maskFormatter.getUnmaskedText().trim().isEmpty) {
        throw ("Please enter Mobile no");
      } else if (selectedDate == null) {
        throw ("Please enter Birthday");
      } else if (emailEditingControler.text.trim().isEmpty) {
        throw ("Please enter email");
      } else if (!validateEmail.hasMatch(emailEditingControler.text)) {
        throw ("Invalid  email address");
      } else if (heightFormater.getUnmaskedText().trim().isEmpty) {
        throw ("Please enter height");
      } else if (_radioVal.isEmpty) {
        throw ("Please choose gender");
      } else {
        return true;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: error, gravity: ToastGravity.CENTER);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.dstATop),
                image: AssetImage("assets/slide1.jpg"),
                fit: BoxFit.cover,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   'Love Me',
                  //   style: TextStyle(
                  //       color: Colors.red,
                  //       fontSize: 42,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Container(
                    height: 120.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 12.0, right: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: userNameEditingControler,
                      decoration: InputDecoration(
                          hintText: "Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 12.0, right: 12.0),
                    child: TextField(
                      inputFormatters: [maskFormatter],
                      keyboardType: TextInputType.phone,
                      controller: mobileEditingControler,
                      decoration: InputDecoration(
                          hintText: "Mobile No(Ex-77 12 34567)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 12.0, right: 12.0),
                    child: DateTimeFormField(
                      mode: DateTimeFieldPickerMode.date,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Birthday',
                        border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 12.0, right: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailEditingControler,
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 12.0, right: 12.0),
                    child: TextField(
                      inputFormatters: [heightFormater],
                      keyboardType: TextInputType.number,
                      controller: heightEditingControler,
                      decoration: InputDecoration(
                          hintText: "Height(ft)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 14.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Gender',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Row(
                      children: [
                        Text('Male',
                            style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                color: Colors.black)),
                        Radio(
                            value: 1,
                            groupValue: _radioSelected,
                            activeColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value;
                                _radioVal = 'male';
                              });
                            }),
                        Text('Female',
                            style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                color: Colors.black)),
                        Radio(
                            value: 2,
                            groupValue: _radioSelected,
                            activeColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value;
                                _radioVal = 'female';
                              });
                            }),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    child: Text("CONTINUE"),
                    onPressed: () {
                      if (validateFields()) {
                        service.createUser(
                            userNameEditingControler.text,
                            maskFormatter.getUnmaskedText().toString(),
                            emailEditingControler.text,
                            selectedDate,
                            _radioVal,
                            heightFormater.getMaskedText().toString(),
                            context);
                      }
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        elevation: 3,
                        backgroundColor: const Color(0xFF7E0F4A),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        padding: EdgeInsets.symmetric(horizontal: 80)),
                  ),

                  ElevatedButton(
                    child: Text("Check Partner List"),
                    onPressed: () {
                      if (true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainMenu(
                                      isReg: false,
                                    )));
                      }
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        elevation: 3,
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        padding: EdgeInsets.symmetric(horizontal: 80)),
                  ),
                  // TextButton(
                  //   child: Text("Already have a account?"),
                  //   onPressed: () => {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => Login()),
                  //     ),
                  //   },
                  // )
                ],
              )),
        ),
      ),
    );
  }
}
