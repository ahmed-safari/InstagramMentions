import 'package:flutter/material.dart';
import 'package:instagram_mentions/components/constants.dart';
import 'package:instagram_mentions/components/user_card.dart';
import 'package:instagram_mentions/models/story.dart';
import 'package:instagram_mentions/screens/story_info_screen.dart';
import 'package:intl/intl.dart';

class StoriesScreen extends StatefulWidget {
  final List<Story> stories;
  StoriesScreen({this.stories});
  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
          ),
          Text(
            'Stories Posted By',
            style: TextStyle(fontSize: 20),
          ),
          UserCard(
            user: widget.stories[0].posterUser,
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 255,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 0),
              itemCount: widget.stories.length,
              itemBuilder: (BuildContext context, int index) {
                return StoryCard(
                  story: widget.stories[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  final Story story;
  StoryCard({this.story});

  final f = new DateFormat('yyyy-MM-dd hh:mm');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoryInfoScreen(
                    story: story,
                  ))),
      child: Container(
        alignment: Alignment.center,
        height: 80,
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.only(top: 4, left: 20, right: 20),
        decoration: BoxDecoration(
          color: kThemeColor,
          borderRadius: BorderRadius.circular(10),
          //boxShadow: [kContainersShadow],
        ),
        child: ListTile(
          leading: Image(
            image: NetworkImage(story.imageURL),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Text(
                story.hasMentions
                    ? story.mentions.length.toString() + ' Mention(s) Found'
                    : 'No Mentions Found',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Taken At: ' +
                    f.format(DateTime.fromMillisecondsSinceEpoch(
                        story.takenAt * 1000)),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w500, height: 1.25),
              ),
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          dense: true,
          isThreeLine: true,
          visualDensity: VisualDensity(horizontal: -1, vertical: -1),
        ),
      ),
    );
  }
}
