import 'package:chat_app/widgets/SquareAvatar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:chat_app/models/FriendsModel.dart';
import 'package:chat_app/config/color_palette.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key key}) : super(key: key);

  @override
  FriendsState createState() => new FriendsState();
}

class FriendsState extends State<FriendsPage> {
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 12.0);
  List<FriendsModel> _listFriends;

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
          physics:
              BouncingScrollPhysics(), //animation when scrolling top  end and bottom end
          itemCount: _listFriends.length,
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

  Widget _buildRow(FriendsModel friendsModel) {
    return new ListTile(
      leading: new SquareAvatar(
        friendsModel.profileImageUrl,
      ), //custom widget SquareAvatar
      title: new Text(
        friendsModel.name,
        style: _biggerFont,
      ),
      trailing: ElevatedButton(
        onPressed: () {},
        child: const Text(
          'Send Request',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          primary: sendrequestbutton, // background
        ),
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  _fetchFriendsList() async {
    _isProgressBarShown = true;
    var url = 'https://randomuser.me/api/?results=100&nat=us';
    var httpClient = new HttpClient();

    List<FriendsModel> listFriends = <FriendsModel>[];
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
          FriendsModel friendsModel = new FriendsModel(name, profileUrl);
          listFriends.add(friendsModel);
          print(friendsModel.profileImageUrl);
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
