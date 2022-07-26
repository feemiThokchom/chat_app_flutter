//Packages
import 'package:chat_app_flutter/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

//Services
import '../services/database_service.dart';
import '../services/navigation_services.dart';

//Models
import '../models/chat_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationServices _navigationServices;
  late final DatabaseServices _databaseServices;

  late ChatUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _databaseServices = GetIt.instance.get<DatabaseServices>();
    _navigationServices = GetIt.instance.get<NavigationServices>();

    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _databaseServices.updateUserLastSeen(_user.uid);
        _databaseServices.getUser(_user.uid).then(
              (_snapshot) {
                if(_snapshot.exists) {
              Map<String, dynamic> userData =
                  _snapshot.data() as Map<String, dynamic>;
              user = ChatUser.fromJson({
                "uid": _user.uid,
                "name": userData["name"],
                "email": userData["email"],
                "last_active": userData["last_active"],
                "image": userData["image"],
              });
              _navigationServices.removeAndNavigateToRoute('/home');
            }
          },
        );
      } else {
        _navigationServices.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email,
      String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(_auth.currentUser);
    } on FirebaseAuthException {
      print("Error logging user into Firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,);
      return credentials.user!.uid;
    } on FirebaseAuthException{
      print("Error in registering user.");
    }catch (e){
      print(e);
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
