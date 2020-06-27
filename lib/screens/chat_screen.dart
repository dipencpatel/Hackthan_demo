import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:demo/provider/Model/chatmodel.dart';
import 'package:demo/api_manager/constant.dart';
import 'package:demo/provider/Model/user.dart';
import 'package:demo/utility/common_methods.dart';

final database = FirebaseDatabase.instance;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  User userMine = User(
      user_id: "1YTHlthZVQPxzSFlIN9afG7dUSU2",
      user_email: "mirant.patel@gmail.com");
  User userOther = User(
      user_id: "G2iAxPZqlwXi348vUfxcCJ3dQBu1",
      user_email: "ankit_khatri@gmail.com");

  final _childSenderQuery = database.reference().child(keyTableMainChild);
  StreamSubscription<Event> _onChatAddedSenderSubscription;

  List<Chat> listChatAllData = [];
  String keyChatRoom;

  var isOpenKeyboard = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    keyChatRoom = createKeyForChatRoom([userMine, userOther]);

    _onChatAddedSenderSubscription =
        _childSenderQuery.child(keyChatRoom).onChildAdded.listen(_getReadData);
  }

  @override
  void dispose() {
    _onChatAddedSenderSubscription.cancel();
    super.dispose();
  }

  void sendData(Chat objChat) {
    _childSenderQuery.child(keyChatRoom).push().set(objChat.toMap()).then((_) {
      print(objChat.toMap());
    });
  }

  void _getReadData(Event event) {
    Chat objChat = Chat.fromSnapshot(event.snapshot);
//    print("Mirant${event.snapshot.value}");

    setState(() {
      listChatAllData.add(objChat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                  itemCount: listChatAllData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        precisionChatText(
                            listChatAllData[index], userMine, userOther),
                        style: TextStyle(
                            color: isMyMessage(
                                listChatAllData[index], userMine, userOther)
                                ? Colors.white
                                : Colors.lightGreen,
                            fontSize: 18.0),
                      ),
                    );
                  },
                )),
            Container(
              height: isOpenKeyboard ? 250 : 0,
              width: double.infinity,
              color: (Colors.orange),
            )
          ],
        ),
      ),
    );
  }
}
