
import 'package:flutter/material.dart';

//Packages
import 'package:provider/provider.dart';

// pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import './pages/register_page.dart';
// services
import './services/navigation_services.dart';

//Providers
import './providers/authentication_provider.dart';

void main() {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitializationComplete: () {
      runApp(
        MainApp(),
      );
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthenticationProvider>(
            create: (BuildContext context) {
              return AuthenticationProvider();
            },
          )
        ],
        child: MaterialApp(
          title: 'Chat App',
          theme: ThemeData(
            backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
            scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
            ),
          ),
          navigatorKey: NavigationServices.navigatorKey,
          initialRoute: '/login',
          routes: {
            '/login': (BuildContext context) => LoginPage(),
            '/home': (BuildContext context) => HomePage(),
            '/register': (BuildContext context) => RegisterPage(),
          },
        ));
  }
}
