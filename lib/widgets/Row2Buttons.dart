import 'package:flutter/material.dart';
import 'package:chat_app/config/color_palette.dart';
import 'package:flutter/widgets.dart';

class Row2Buttons extends StatelessWidget {
  final String buttonOneTitle;
  final String buttonTwoTitle;

  Row2Buttons(
    this.buttonOneTitle,
    this.buttonTwoTitle,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 4),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              buttonOneTitle,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(70, 1),
              primary: sendrequestbutton, // background
            ),
          ),
        ),
        Container(
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              buttonTwoTitle,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(70, 1),
              primary: sendrequestbutton, // background
            ),
          ),
        ),
      ],
    );
  }
}
