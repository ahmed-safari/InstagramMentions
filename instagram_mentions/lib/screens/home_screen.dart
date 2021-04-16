import 'package:flutter/material.dart';
import 'package:instagram_mentions/components/constants.dart';
import 'package:instagram_mentions/components/error_container.dart';
import 'package:instagram_mentions/components/user_card.dart';
import 'package:instagram_mentions/components/user_card.dart';
import 'package:instagram_mentions/models/logged_user.dart';
import 'package:instagram_mentions/models/get_stories_response.dart';
import 'package:instagram_mentions/models/user.dart';
import 'package:instagram_mentions/screens/stories_screen.dart';
import 'package:instagram_mentions/services/instagram_api.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  final LoggedUser user;
  final InstagramAPI api;

  HomeScreen({this.user, this.api});
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';
  String infoMessage = '';
  String errorMessage = '';
  var mentionedUsers = [];
  bool showError = false;
  bool isInfo = false;
  RoundedLoadingButtonController _searchBtnController =
      new RoundedLoadingButtonController();
  Future getStories() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      showError = false;
      isInfo = false;
      mentionedUsers = [];
    });
    // RegExp linkRegex = new RegExp(
    //   r"(\d{9,})",
    //   caseSensitive: false,
    //   multiLine: false,
    // );
    // RegExp usernameRegex = new RegExp(
    //   r"(?<=stories\/).*?(?=\/)",
    //   caseSensitive: false,
    //   multiLine: false,
    // );

    // String storyID = linkRegex.stringMatch(userID);
    //String username = usernameRegex.stringMatch(userID);

    if (username == '') {
      print('Error');
      setState(() {
        showError = true;
        errorMessage = 'The Username Cannot Be Blank';
      });
      _searchBtnController.reset();
      return null;
    }
    GetStoriesResponse response =
        await widget.api.getStories(username: username);
    if (response.isSuccess) {
      mentionedUsers = response.stories;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoriesScreen(
              stories: response.stories,
            ),
          ));
      // setState(() {
      //   isInfo = true;
      //   infoMessage =
      //       'Found ' + mentionedUsers.length.toString() + ' Mention(s)';
      // });
    } else {
      setState(() {
        errorMessage = response.errorMsg;
        showError = true;
      });
    }

    _searchBtnController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 100, bottom: 50),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(widget.user.profilePic),
                ),
              ),
              Text(
                'Hello, ' + widget.user.fullName,
                style: TextStyle(fontSize: 25),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 25, bottom: 15),
                child: TextField(
                  onChanged: (text) {
                    username = text;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(),
                      hintText: "Username ( without the @ )",
                      fillColor: kThemeColor),
                ),
              ),
              ErrorContainer(
                bgColor: Color(0xFFBF0426),
                isVisible: showError,
                errorText: errorMessage,
              ),
              SizedBox(
                height: 10,
              ),
              RoundedLoadingButton(
                controller: _searchBtnController,
                width: MediaQuery.of(context).size.width * 0.7,
                height: 45,
                color: kThemeColor,
                onPressed: () {
                  //widget.api.getUserID(username: '710x');
                  getStories();
                },
                child: Text(
                  'Get Stories',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ErrorContainer(
                bgColor: Color(0xFF404040),
                isVisible: isInfo,
                errorText: infoMessage,
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   height: 250,
              //   // color: Colors.black,
              //   child: ListView.builder(
              //     padding: EdgeInsets.symmetric(vertical: 0),
              //     itemCount: mentionedUsers.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return UserCard(
              //         user: mentionedUsers[index],
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
