import 'package:chat_app_flutter/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Pages



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late AuthenticationProvider _auth;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _auth.logOut();
          },
          child: Text('Log Out'),
        ),
      ),
    );
  }
}
