import 'package:chat_app/widgets/SquareAvatar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:chat_app/models/FriendsMessageModel.dart';

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);

  @override
  MessagesState createState() => new MessagesState();
}

class MessagesState extends State<Messages> {
  bool _isProgressBarShown = true;
  final _tileFont = const TextStyle(fontSize: 12.0);
  final _messageFont = const TextStyle(fontSize: 10.0);
  final _messageTime = const TextStyle(fontSize: 9.0);
  List<FriendsMessage> _listFriends;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (_isProgressBarShown) {
      widget = new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new CircularProgressIndicator()));
    } else {
      widget = new ListView.builder(
          itemCount: _listFriends.length,
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return new Divider();
            return _buildRow(_listFriends[i]);
          });
    }

    return new Scaffold(
      body: widget,
    );
  }

  Widget _buildRow(FriendsMessage friendsMessageModel) {
    return new ListTile(
      leading: new SquareAvatar(
        friendsMessageModel.profileImageUrl,
        isActive: friendsMessageModel.isActive,
      ), //custom widget SquareAvatar
      title: new Text(
        friendsMessageModel.name,
        style: _tileFont,
      ),
      subtitle: new Text(
        friendsMessageModel.latestMessage,
        style: _messageFont,
      ),
      onTap: () {
        setState(() {});
      },
      dense: true,
      trailing: Text(
        'Just Now',
        style: _messageTime,
      ),
    );
  }

  _fetchFriendsList() async {
    _isProgressBarShown = true;
    var url = 'https://randomuser.me/api/?results=100&nat=us';
    var httpClient = new HttpClient();

    List<FriendsMessage> listFriends = <FriendsMessage>[];
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        Map data = jsonDecode(json);

        for (var res in data['results']) {
          var objName = res['name'];
          String name =
              objName['first'].toString() + " " + objName['last'].toString();

          var objImage = res['picture'];
          String profileUrl = objImage['large'].toString();

          var objlocation = res['location']; //testing data change
          var objTimezone = objlocation['timezone'];
          String latestMessage = objTimezone['description'].toString();

          var objGender = res['gender'];
          bool isActive = objGender.toString() == 'female'
              ? true
              : false; //testing data change
          var objactivetime = res['location']; //testing data change
          objactivetime = objactivetime['street'];
          String latestMessageTime = objactivetime['number'].toString();

          FriendsMessage friendsMessageModel = new FriendsMessage(
              name, profileUrl, latestMessage, latestMessageTime, isActive);
          listFriends.add(friendsMessageModel);
          print(friendsMessageModel.profileImageUrl);
          print(friendsMessageModel.latestMessageTime);
          print(friendsMessageModel.latestMessage);

          print(friendsMessageModel.isActive);
        }
      }
    } catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      _listFriends = listFriends;
      _isProgressBarShown = false;
    });
  }
}
