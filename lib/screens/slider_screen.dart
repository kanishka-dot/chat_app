import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroSliderPage extends StatelessWidget {
  final pageDecoration = PageDecoration();

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset(
            "assets/slide1.jpg",
            scale: 8,
          ),
          title: "Hello love Seekers",
          body: "This is yours personal app"),
      PageViewModel(
          image: Image.asset(
            "assets/slide2.jpg",
            scale: 8,
          ),
          title: "Hello love Seekers",
          body: "This is yours personal app"),
      PageViewModel(
          image: Image.asset(
            "assets/slide3.jpg",
            scale: 8,
          ),
          title: "Hello love Seekers",
          body: "This is yours personal app"),
      PageViewModel(
          image: Image.asset(
            "assets/slide4.jpg",
            scale: 8,
          ),
          title: "Hello love Seekers",
          body: "This is yours personal app")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        done: Text("Lets Start"),
        onDone: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Register()));
        },
        onSkip: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
        },
        showNextButton: false,
        skip: Text('Skip'),
        showSkipButton: true,
      ),
    );
  }
}
