//packages
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_cOLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "Messages";

class DatabaseServices {
  final  _db = FirebaseFirestore.instance;

  DatabaseServices();
}