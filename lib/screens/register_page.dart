import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  TextEditingController emailEditingControler = TextEditingController();
  TextEditingController userNameEditingControler = TextEditingController();
  TextEditingController passwordEditingControler = TextEditingController();
  Service service = Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text("Get In"),
                onPressed: () => {
                  if (emailEditingControler.text.isNotEmpty)
                    {
                      if (emailEditingControler.text.length != 10)
                        {service.errorHandle(context, "Invalid Phone Number")}
                      else
                        {
                          service.createUser(
                              emailEditingControler.text, context)
                        }
                    }
                  else
                    {service.errorHandle(context, "Please enter Phone Number")}
                },
                style: TextButton.styleFrom(
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
