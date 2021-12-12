import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Test extends StatefulWidget {
  // const Messages({ Key? key }) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
            child: Text("Get In"),
            onPressed: () => {EasyLoading.show(status: 'loading...')}),
      ),
    );
  }
}
