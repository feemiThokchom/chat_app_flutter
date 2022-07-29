import 'dart:async';

//packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//services
import '../services/database_service.dart';

//providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat_user.dart';
import '../models/chat_message.dart';
import '../models/chat.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseServices _db;

  List<Chat>? chats;

  late StreamSubscription _chatStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseServices>();
    getChats();
  }

  @override
  void dispose() {
    _chatStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatStream =
          _db.getChatsForUser(_auth.user.uid).listen((_snapshot) async {
        chats = await Future.wait(
          _snapshot.docs.map(
            (_d) async {
              Map<String, dynamic> _chatData =
                  _d.data() as Map<String, dynamic>;

              //Get Users in chat
              List<ChatUser> _members = [];
              for (var _uid in _chatData["members"]) {
                DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
                Map<String, dynamic> _userData =
                    _userSnapshot.data() as Map<String, dynamic>;
                _userData["uid"] = _userSnapshot.id;
                _members.add(
                  ChatUser.fromJSON(_userData),
                );
              }

              //Get Last Message for chat
              List<ChatMessage> _messages = [];
              QuerySnapshot _chatMessage =
                  await _db.getLastMessageFromChat(_d.id);
              if (_chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> _messageData =
                    _chatMessage.docs.first.data()! as Map<String, dynamic>;
                ChatMessage _message = ChatMessage.fromJSON(_messageData);
                _messages.add(_message);
              }

              //  Return chats Instance
              return Chat(
                uid: _d.id,
                currentUserUid: _auth.user.uid,
                members: _members,
                messages: _messages,
                activity: _chatData["is_activity"],
                group: _chatData["is_group"],
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print('Error getting chats.');
      print(e);
    }
  }
}
