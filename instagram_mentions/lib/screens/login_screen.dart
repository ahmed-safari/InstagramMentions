import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instagram_mentions/components/constants.dart';
import 'package:instagram_mentions/components/error_container.dart';
import 'package:instagram_mentions/models/logged_user.dart';
import 'package:instagram_mentions/models/login_response.dart';
import 'package:instagram_mentions/screens/home_screen.dart';
import 'package:instagram_mentions/services/instagram_api.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final api = InstagramAPI();
  RoundedLoadingButtonController _loginBtnController =
      new RoundedLoadingButtonController();
  String errorMessage = '';
  bool showError = false;
  String username, password = '';
  Future login() async {
    showError = false;
    if (username == '' || password == '') {
      setState(() {
        errorMessage = 'Username and Password must not be empty';
        showError = true;
        _loginBtnController.error();
        Timer(Duration(seconds: 2), () {
          _loginBtnController.reset();
        });
      });
      return null;
    }

    LoginResponse response =
        await api.login(username: username, password: password);
    if (response.isSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: response.userData,
              api: api,
            ),
          ));
    } else {
      //Error
      setState(() {
        errorMessage = response.errorMsg;
        showError = true;
        _loginBtnController.error();
        Timer(Duration(seconds: 2), () {
          _loginBtnController.reset();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(image: AssetImage('assets/login.jpg')),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: (text) {
                      username = text;
                    },
                    decoration: InputDecoration(
                        hintText: 'Username',
                        hoverColor: kThemeColor,
                        focusColor: kThemeColor),
                  ),
                  TextField(
                    obscureText: true,
                    onChanged: (text) {
                      password = text;
                    },
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  SizedBox(height: 35),
                  ErrorContainer(
                    bgColor: Color(0xFFBF0426),
                    isVisible: showError,
                    errorText: errorMessage,
                  ),
                  SizedBox(height: 25),
                  RoundedLoadingButton(
                    controller: _loginBtnController,
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 45,
                    color: kThemeColor,
                    onPressed: () => login(),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () => login(),
                  //   child: Text('Login'),
                  // )
                ],
              ),
            ),
            Text('Made With <3 By Spoods ( @710x )')
          ],
        ),
      ),
    );
  }
}
