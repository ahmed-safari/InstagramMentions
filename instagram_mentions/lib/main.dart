import 'package:flutter/material.dart';
import 'package:instagram_mentions/components/constants.dart';
import 'package:instagram_mentions/models/logged_user.dart';
import 'package:instagram_mentions/screens/home_screen.dart';
import 'package:instagram_mentions/screens/login_screen.dart';
import 'package:instagram_mentions/screens/stories_screen.dart';

void main() {
  runApp(MyApp());
  LoggedUser(
      username: 'Test',
      userID: 12345,
      fullName: 'Ahmed Yousef',
      profilePic:
          'https://instagram.fdoh4-2.fna.fbcdn.net/v/t51.2885-19/s150x150/104237501_2564223407128139_8753681656526418213_n.jpg?tp=1&_nc_ht=instagram.fdoh4-2.fna.fbcdn.net&_nc_ohc=Zpq1jtDNcAAAX-DCy73&edm=ABfd0MgAAAAA&ccb=7-4&oh=3ce5425197f4d714195fd17a3e22ae2c&oe=609E30FF&_nc_sid=7bff83');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Mentions',
        theme: ThemeData.dark().copyWith(
            accentColor: Color(0xFFD90416),
            scaffoldBackgroundColor: Color(0xFF0D0D0D),
            appBarTheme: AppBarTheme(backgroundColor: kThemeColor)),
        home: LoginScreen());
  }
}
