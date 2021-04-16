import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:instagram_mentions/components/constants.dart';
import 'package:instagram_mentions/components/user_card.dart';
import 'package:instagram_mentions/models/story.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class StoryInfoScreen extends StatefulWidget {
  final Story story;
  StoryInfoScreen({this.story});
  @override
  _StoryInfoScreenState createState() => _StoryInfoScreenState();
}

class _StoryInfoScreenState extends State<StoryInfoScreen> {
  RoundedLoadingButtonController _downloadBtnController =
      new RoundedLoadingButtonController();
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Permission Not Granted'),
                Text('You Need To Give Me Permission To Your Photo Gallery.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _save() async {
    try {
      print(widget.story.videoURL);
      final targetUrl = widget.story.mediaType == 1
          ? widget.story.imageURL
          : widget.story.videoURL;
      var imageId = await ImageDownloader.downloadImage(targetUrl);
      if (imageId == null) {
        _downloadBtnController.error();
        await _showMyDialog();
        _downloadBtnController.reset();
        return;
      }
      _downloadBtnController.success();
      Timer(Duration(seconds: 2), () {
        _downloadBtnController.reset();
      });
      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } catch (error) {
      print(error);

      _downloadBtnController.error();
      Timer(Duration(seconds: 2), () {
        _downloadBtnController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image(
                width: 200,
                image: NetworkImage(widget.story.imageURL),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            RoundedLoadingButton(
              controller: _downloadBtnController,
              width: MediaQuery.of(context).size.width * 0.7,
              height: 45,
              color: kThemeColor,
              onPressed: () {
                _save();
              },
              child: Text(
                'Download Story',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible: widget.story.hasMentions,
              child: Text(
                'Mentions',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible: widget.story.hasMentions,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    color: Color(0xFF080707),
                    borderRadius: BorderRadius.circular(20)),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  itemCount: widget.story.hasMentions
                      ? widget.story.mentions.length
                      : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return UserCard(
                      user: widget.story.mentions[index],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
