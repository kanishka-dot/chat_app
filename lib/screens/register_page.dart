import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  TextEditingController emailEditingControler = TextEditingController();
  TextEditingController userNameEditingControler = TextEditingController();
  TextEditingController mobileEditingControler = TextEditingController();
  String _radioVal = "";
  DateTime selectedDate;
  int _radioSelected;
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find Your Soul Mate',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: userNameEditingControler,
                  decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: mobileEditingControler,
                  decoration: InputDecoration(
                      hintText: "Mobile No",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
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
                            const BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailEditingControler,
                  decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Gender',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
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
                    Text('Other',
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    Radio(
                        value: 3,
                        groupValue: _radioSelected,
                        activeColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            _radioSelected = value;
                            _radioVal = 'other';
                          });
                        })
                  ],
                ),
              ),

              ElevatedButton(
                child: Text("CONTINUE"),
                onPressed: () => {
                  if (emailEditingControler.text.isNotEmpty)
                    {
                      if (emailEditingControler.text.length != 10)
                        {service.errorHandle(context, "Invalid Phone Number")}
                      else
                        {
                          EasyLoading.show(status: 'Please wait...'),
                          service.createUser(
                              emailEditingControler.text, context),
                          EasyLoading.dismiss()
                        }
                    }
                  else
                    {service.errorHandle(context, "Please enter Phone Number")}
                },
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    elevation: 3,
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
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
          ),
        ),
      ),
    );
  }
}
