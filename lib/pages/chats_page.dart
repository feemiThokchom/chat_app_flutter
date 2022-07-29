//packages
import 'package:chat_app_flutter/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//Providers
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

//widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

//Models
import '../models/chat.dart';
import '../models/chat_user.dart';
import '../models/chat_message.dart';

//service
import '../services/navigation_services.dart';

//page
import '../pages/chat_page.dart';

class ChatsPages extends StatefulWidget {
  const ChatsPages({Key? key}) : super(key: key);

  @override
  State<ChatsPages> createState() => _ChatsPagesState();
}

class _ChatsPagesState extends State<ChatsPages> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;

  late ChatsPageProvider _pageProvider;
  late NavigationServices _navigation;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationServices>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _pageProvider = context.watch<ChatsPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Chats',
                primaryAction: IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                  onPressed: () {
                    _auth.logOut();
                  },
                ),
              ),
              _chatList(),
            ],
          ),
        );
      },
    );
  }

  Widget _chatList() {
    List<Chat>? _chats = _pageProvider.chats;
    print(_chats?.length);
    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.length != 0) {
            return ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (BuildContext context, index) {
                return _chatTile(_chats[index]);
              },
            );
          } else {
            return Center(
              child: Text(
                'No Chats Found ',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    bool _isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subtitleText = "";
    if (_chat.messages.isNotEmpty) {
      _subtitleText = _chat.messages.first.type != MessageType.TEXT
          ? "Media File"
          : _chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
        height: _deviceHeight * 0.10,
        title: _chat.title(),
        subtitle: _subtitleText,
        imagePath: _chat.imageUrl(),
        isActive: _isActive,
        isActivity: _chat.activity,
        onTap: () {
          _navigation.navigateToPage(
            ChatPage(
              chat: _chat,
            ),
          );
        });
  }
}
