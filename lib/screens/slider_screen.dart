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
            "assets/slide2.jpg",
            scale: 8,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          decoration: PageDecoration(imageFlex: 5),
          title: "Hello love Seekers",
          body: "This is your personal app, Find your soul mate"),
      PageViewModel(
          image: Image.asset(
            "assets/slide4.jpg",
            scale: 8,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          decoration: PageDecoration(imageFlex: 5),
          title: "Your Dream Love",
          body: "Find your best match to make love"),
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
              context, MaterialPageRoute(builder: (context) => Register()));
        },
        showNextButton: false,
        skip: Text('Skip'),
        showSkipButton: true,
      ),
    );
  }
}
