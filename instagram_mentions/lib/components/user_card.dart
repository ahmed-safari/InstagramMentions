import 'dart:core';

import 'package:flutter/material.dart';
import 'package:instagram_mentions/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCard extends StatelessWidget {
  final User user;
  UserCard({this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => launch('https://instagram.com/' + user.username),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.95,
            height: 85,
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              //boxShadow: [kContainersShadow],
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.green,
                backgroundImage: NetworkImage(user.profilePic),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(user.fullName,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('@' + user.username,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 11,
                          //color: kUnselected,
                          fontWeight: FontWeight.w500,
                          height: 1.25)),
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              dense: true,
              isThreeLine: true,
              visualDensity: VisualDensity(horizontal: -1, vertical: -1),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 2,
          color: Colors.grey.withOpacity(0.2),
        )
      ],
    );
  }
}
