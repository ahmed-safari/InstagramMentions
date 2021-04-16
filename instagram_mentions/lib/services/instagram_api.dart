import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instagram_mentions/models/logged_user.dart';
import 'package:instagram_mentions/models/login_response.dart';
import 'package:instagram_mentions/models/get_stories_response.dart';
import 'package:instagram_mentions/models/story.dart';
import 'package:instagram_mentions/models/user.dart';

class InstagramAPI {
  String rawCookie;
  Map<String, String> cookies = {};

  void _updateCookie() {
    if (rawCookie != null) {
      var setCookies = rawCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }
    }
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        this.cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += ";";
      cookie += key + "=" + cookies[key];
    }

    return cookie;
  }

  Future login({username, password}) async {
    print('Logging In..');
    try {
      var headers = {
        "User-Agent":
            "Instagram 103.1.0.15.119 (iPhone10,6; iOS 12_4; en_US; en-US; scale=3.00; gamut=wide; 1125x2001) AppleWebKit/420+"
      };
      var uuid = '11bf5b37-e0b8-42e0-8dcf-dc8c4aefc000';

      var data = {
        "_csrftoken": "missing",
        "username": username,
        "password": password,
        "login_attempt_count": "0",
        "device_id": uuid
      };

      var response = await http.post(
          Uri.parse('https://i.instagram.com/api/v1/accounts/login/'),
          headers: headers,
          body: data);
      print(response.body);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['status'] == 'fail') {
        return LoginResponse(
            errorMsg: responseData['message'],
            isSuccess: false,
            userData: null);
      } else {
        rawCookie = response.headers['set-cookie'];
        print(rawCookie);
        return LoginResponse(
          isSuccess: true,
          errorMsg: null,
          userData: LoggedUser(
              username: responseData['logged_in_user']['username'],
              fullName: responseData['logged_in_user']['full_name'],
              userID: responseData['logged_in_user']['pk'],
              profilePic: responseData['logged_in_user']['profile_pic_url']),
        );
      }
    } catch (e) {
      print(e.toString());
      return LoginResponse(
          errorMsg: e.toString(), isSuccess: false, userData: null);
    }
  }

  Future getUserID({username}) async {
    //print('rawCookie: \n' + rawCookie);

    try {
      var headers = {
        "User-Agent":
            "Instagram 103.1.0.15.119 (iPhone10,6; iOS 12_4; en_US; en-US; scale=3.00; gamut=wide; 1125x2001) AppleWebKit/420+"
      };

      this._updateCookie();
      headers['cookie'] = this._generateCookieHeader();

      var response = await http.get(
        Uri.parse('https://i.instagram.com/api/v1/users/' +
            username +
            '/usernameinfo/'),
        headers: headers,
      );
      // print(response.body);
      // print(response.statusCode);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      //print(responseData['user']['pk']);
      return responseData['user']['pk'].toString();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getStories({username}) async {
    try {
      var headers = {
        "User-Agent":
            "Instagram 103.1.0.15.119 (iPhone10,6; iOS 12_4; en_US; en-US; scale=3.00; gamut=wide; 1125x2001) AppleWebKit/420+"
      };

      this._updateCookie();
      headers['cookie'] = this._generateCookieHeader();
      String userID = await getUserID(username: username);
      var response = await http.get(
        Uri.parse(
            'https://i.instagram.com/api/v1/feed/user/' + userID + '/story/'),
        headers: headers,
      );
      //print(response.body);
      print(response.statusCode);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<Story> stories = Story().parseStories(responseData);
      print(stories[0].imageURL);
      // print('There Are ' + stories.length.toString() + ' Stories');

      return GetStoriesResponse(isSuccess: true, stories: stories);
    } catch (e) {
      print(e.toString());
      return GetStoriesResponse(
          errorMsg: e.toString(), isSuccess: false, stories: null);
    }
  }
}
