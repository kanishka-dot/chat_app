import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/widgets/TimeStampToDate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class Message extends StatefulWidget {
  final String receiverId;

  @override
  _MessageState createState() => _MessageState(receiverId: receiverId);

  Message({@required this.receiverId});
}

class _MessageState extends State<Message> {
  TextEditingController messageTextControler = TextEditingController();
  Service service = Service();
  final auth = FirebaseAuth.instance;
  final messageStore = FirebaseFirestore.instance;
  String receiverId;
  String id;
  File imageFile;
  String imageUrl;
  bool isLoading = false;
  File tempImage;

  // AudioCache _audioCache;

  String chatId;
  SharedPreferences preferances;

  _MessageState({@required this.receiverId});

  @override
  void initState() {
    super.initState();
    chatId = "";
    // _audioCache = AudioCache(
    //   prefix: 'assets/',
    //   fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    // );

    readLocal();
  }

  readLocal() async {
    preferances = await SharedPreferences.getInstance();
    id = preferances.getString("id") ?? await service.getToken();

    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
    }

    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'chattingwith': receiverId});
    setState(() {});
  }

  Future getImage() async {
    final picker = ImagePicker();
    PickedFile pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 85);
    imageFile = File(pickedFile.path);

    // if (imageFile != null) {
    //   isLoading = true;
    // }

    setState(() {
      tempImage = imageFile;
    });

    _cropImage();
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper().cropImage(sourcePath: tempImage.path);
    setState(() {
      if (cropped != null) {
        this.imageFile = cropped;
        isLoading = true;
      }
    });

    uploadImageFile();
  }

  uploadImageFile() async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference storageReferance =
        FirebaseStorage.instance.ref().child("Chat Image").child(fileName);

    UploadTask storageUploadTask = storageReferance.putFile(imageFile);
    TaskSnapshot storageTaskSnapShot = await storageUploadTask.whenComplete(
      () => storageReferance.getDownloadURL().then((downloadURL) {
        imageUrl = downloadURL;
        onSendMessage(imageUrl, 2);
        setState(() {
          isLoading = false;
        });
      }, onError: (error) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Error occured sending image");
      }),
    );
  }

  onSendMessage(String content, int type) {
    messageStore
        .collection("messages")
        .doc(chatId)
        .collection(chatId)
        .doc(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      "message": content,
      "sent_by": loginUser.uid.toString(),
      "received_by": receiverId,
      "type": type,
      "time": DateTime.now(),
    });

    messageStore //update last chat time in user
        .collection("friends")
        .doc(id)
        .collection('friends')
        .doc(receiverId)
        .update({
      'last_chat': DateTime.now(),
    });

    messageStore //update last chat time in reciver
        .collection("friends")
        .doc(receiverId)
        .collection('friends')
        .doc(id)
        .update({
      'last_chat': DateTime.now(),
    });
  }

  createListMessage() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .doc(chatId)
          .collection(chatId)
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
        } else {
          print(snapshot.data.docs);
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            reverse: true,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            primary: true,
            itemBuilder: (context, i) {
              QueryDocumentSnapshot x = snapshot.data.docs[i];

              return ListTile(
                title: Column(
                    crossAxisAlignment: loginUser.uid == x['sent_by']
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      x['type'] == 1
                          ? Container(
                              decoration: BoxDecoration(
                                  color: loginUser.uid == x['sent_by']
                                      ? Colors.blue.withOpacity(0.5)
                                      : Colors.amber.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    x['message'],
                                  ),
                                  TimeStampToDate(x['time']),
                                ],
                              ))
                          : Container(
                              child: TextButton(
                                child: Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.lightBlueAccent),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(70.0),
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Material(
                                      child: Image.asset(
                                        'assets/errorimage.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                    imageUrl: x['message'],
                                    width: 200.0,
                                    height: 200.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () => {},
                              ),
                            )
                    ]),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                physics: ScrollPhysics(),
                reverse: false,
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  child: createListMessage(),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                              controller: messageTextControler,
                              enableSuggestions: true,
                              decoration: InputDecoration(
                                  hintText: "Type a Message",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: getImage,
                          icon: Icon(
                            Icons.image,
                            size: 25,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: Container(
                    height: 47,
                    width: 47,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blueGrey),
                    child: Icon(
                      Icons.send,
                      size: 33,
                    ),
                  ),
                  onTap: () => {
                    // _audioCache.play('tap.mp3'),
                    if (messageTextControler.text.trim().isNotEmpty)
                      {onSendMessage(messageTextControler.text, 1)},
                    if (messageTextControler.text.isNotEmpty)
                      {messageTextControler.clear()}
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
