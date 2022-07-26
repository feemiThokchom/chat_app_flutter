//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Pages
import '../pages/chats_page.dart';
import '../providers/authentication_provider.dart';
import '../pages/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    ChatsPages(),
    UsersPage(),

  ];

  int _currentPage = 0;

  late AuthenticationProvider _auth;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(

        body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index){
          setState((){
            _currentPage = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Chats',
            icon: Icon(Icons.chat_bubble),
          ),
          BottomNavigationBarItem(
            label: 'Users',
            icon: Icon(Icons.supervised_user_circle_sharp),
          ),

        ],
      ),
    );
  }
}
