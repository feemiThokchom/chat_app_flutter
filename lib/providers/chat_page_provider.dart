import 'dart:async';
import 'dart:ffi';

//Packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_services.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseServices _db;
  late CloudStorageServices _storage;
  late MediaService _media;
  late NavigationServices _navigation;

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messageStream;

  String? _message;

  String get message {
    return message;
  }

  ChatPageProvider(this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseServices>();
    _storage = GetIt.instance.get<CloudStorageServices>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationServices>();
    listenToMessages();
  }

  @override
  void dispose() {
    _messageStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      _messageStream = _db.streamMessagesForChat(_chatId).listen(
        (_snapshot) {
          List<ChatMessage> _messages = _snapshot.docs.map(
            (_m) {
              Map<String, dynamic> _messageData =
                  _m.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(_messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          //Add Scroll to bottom call
        },
      );
    } catch (e) {
      print("Error getting messages");
      print(e);
    }
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        senderID: _auth.user.uid,
        type: MessageType.TEXT,
        content: _message!,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void _sendImageMessage() async {
    try {
      PlatformFile? file = await _media.pickImageFromLibrary();
      if (file != null) {
        String? _downLoadURL = await _storage.saveChatImageToStorage(
          _chatId,
          _auth.user.uid,
          file,
        );
        ChatMessage _messageToSend = ChatMessage(
          senderID: _auth.user.uid,
          type: MessageType.IMAGE,
          content: _downLoadURL!,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatId, _messageToSend,);
      }
    } catch (e) {
      print("Error sending message");
      print(e);
    }
  }

  void _deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
