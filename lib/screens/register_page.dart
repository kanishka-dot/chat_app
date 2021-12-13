import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  TextEditingController emailEditingControler = TextEditingController();
  TextEditingController userNameEditingControler = TextEditingController();
  TextEditingController passwordEditingControler = TextEditingController();
  String _radioVal = "";
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
                  keyboardType: TextInputType.phone,
                  controller: emailEditingControler,
                  decoration: InputDecoration(
                      hintText: "Nick Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 12.0),
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
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: emailEditingControler,
                  decoration: InputDecoration(
                      hintText: "07XXXXXXXX",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 12.0),
              //   child: TextField(
              //     controller: userNameEditingControler,
              //     decoration: InputDecoration(
              //         hintText: "User Name",
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(20))),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 12.0, bottom: 5),
              //   child: TextField(
              //     controller: passwordEditingControler,
              //     decoration: InputDecoration(
              //         hintText: "Enter Password",
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(20))),
              //   ),
              // ), {}
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
