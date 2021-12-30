import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeStampToDate extends StatelessWidget {
  final dateFormat = new DateFormat('yyyy-MM-dd hh:mm');
  final Timestamp timestamp;

  TimeStampToDate(Timestamp this.timestamp);

  @override
  Widget build(BuildContext context) {
    int timeInMilSec = timestamp.microsecondsSinceEpoch;
    var date = new DateTime.fromMicrosecondsSinceEpoch(timeInMilSec);
    String datetime = dateFormat.format(date).toString();

    return Text(
      datetime,
      style: TextStyle(fontSize: 10),
    );
  }
}
