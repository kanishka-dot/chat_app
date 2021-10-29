import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  TextEditingController emailEditingControler = TextEditingController();
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
                'Register',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: TextField(
                  controller: emailEditingControler,
                  decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 5),
                child: TextField(
                  controller: passwordEditingControler,
                  decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              ElevatedButton(
                child: Text("Register"),
                onPressed: () => {
                  if (emailEditingControler.text.isNotEmpty &&
                      passwordEditingControler.text.isNotEmpty)
                    {
                      service.createUser(context, emailEditingControler.text,
                          passwordEditingControler.text)
                    }
                  else
                    {
                      if (emailEditingControler.text.isEmpty)
                        {
                          service.errorHandle(
                              context, "Please enter email address")
                        }
                      else if (passwordEditingControler.text.isEmpty)
                        {service.errorHandle(context, "Please enter password")}
                    }
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80)),
              ),
              TextButton(
                child: Text("Already have a account?"),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  ),
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
