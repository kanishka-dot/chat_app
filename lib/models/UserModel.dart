import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userid;
  String username;
  String email;
  int dob;
  String dpurl;
  String chattingwith = '';
  String citzne;
  String country;
  int cre_date;
  String fcm_token;
  String gender;
  String age;
  String height;
  String job;
  String martial;
  String nochildrn;
  int request_count = 0;
  String residcity;
  String residstat;
  String status;
  String text_status;

  UserModel(
    this.userid,
    this.username,
    this.email,
    this.dob,
    this.dpurl,
    this.chattingwith,
    this.citzne,
    this.country,
    this.cre_date,
    this.fcm_token,
    this.gender,
    this.age,
    this.height,
    this.job,
    this.martial,
    this.nochildrn,
    this.request_count,
    this.residcity,
    this.residstat,
    this.status,
    this.text_status,
  );






  UserModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    username = json['username'];
    email = json['email'];
    dob = toEpoch(json['dob']);
    dpurl = json['dpurl'];
    chattingwith = json['chattingwith'];
    citzne = json['citzne'];
    country = json['country'];
    cre_date = toEpoch(json['cre_date']);
    fcm_token = json['fcm_token'];
    gender = json['gender'];
    age = json['age'];
    height = json['height'];
    job = json['job'];
    martial = json['martial'];
    nochildrn = json['nochildrn'];
    request_count = json['request_count'];
    residcity = json['residcity'];
    residstat = json['residstat'];
    status = json['status'];
    text_status = json['text_status'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['username'] = username;
    data['email'] = email;
    data['dob'] = dob;
    data['dpurl'] = dpurl;
    data['chattingwith'] = chattingwith;
    data['citzne'] = citzne;
    data['country'] = country;
    data['cre_date'] = cre_date;
    data['fcm_token'] = fcm_token;
    data['gender'] = gender;
    data['age'] = age;
    data['height'] = height;
    data['job'] = job;
    data['martial'] = martial;
    data['nochildrn'] = nochildrn;
    data['request_count'] = request_count;
    data['residcity'] = residcity;
    data['residstat'] = residstat;
    data['status'] = status;
    data['text_status'] = text_status;

    return data;
  }



  int toEpoch(dynamic json) {
    if (json is int) {
      return json;
    }
    Timestamp datetime = json;

    return datetime.microsecondsSinceEpoch;
  }
}
