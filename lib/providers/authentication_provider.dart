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
            Map<String, dynamic> _userData = _snapshot.data()! as Map<
                String,
                dynamic>;
            user = ChatUser.fromJson({
              "uid": _user.uid,
              "name": _userData["name"],
              "email": _userData["email"],
              "last_active": _userData["last_active"],
              "image": _userData["image"],
            });
            _navigationServices.removeAndNavigateToRoute('/home');
          },
        );
      } else {
        _navigationServices.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String _email,
      String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print(_auth.currentUser);
    } on FirebaseAuthException {
      print("Error logging user into Firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    }catch (e) {
      print(e);
    }
  }

}
