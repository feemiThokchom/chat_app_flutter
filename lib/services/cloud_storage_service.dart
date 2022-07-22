import 'dart:io';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = "Users";

class CloudStorageServices {
  final _storage = FirebaseStorage.instance;

  CloudStorageServices(){
  }
}