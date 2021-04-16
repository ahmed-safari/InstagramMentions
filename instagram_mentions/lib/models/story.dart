import 'package:instagram_mentions/models/user.dart';

class Story {
  final User posterUser;
  final int takenAt;
  final int pk;
  final int mediaType;
  final String shortcode;
  final String imageURL;
  final String videoURL;
  final bool hasMentions;
  final List<User> mentions;
  Story(
      {this.posterUser,
      this.mentions,
      this.hasMentions,
      this.imageURL,
      this.mediaType,
      this.pk,
      this.shortcode,
      this.takenAt,
      this.videoURL});

  List<Story> parseStories(responseObject) {
    print(responseObject);
    List<Story> stories = [];
    List<User> mentions = [];
    final storyItems = responseObject['reel']['items'];

    for (var i = 0; i < storyItems.length; i++) {
      print('Checking..');
      final hasMentions = storyItems[i]['reel_mentions'];
      if (hasMentions != null) {
        for (var j = 0; j < hasMentions.length; j++) {
          mentions.add(User(
              fullName: storyItems[i]['reel_mentions'][j]['user']['full_name'],
              userID: storyItems[i]['reel_mentions'][j]['user']['pk'],
              username: storyItems[i]['reel_mentions'][j]['user']['username'],
              profilePic: storyItems[i]['reel_mentions'][j]['user']
                  ['profile_pic_url']));
        }
      }

      stories.add(Story(
        imageURL: storyItems[i]['image_versions2']['candidates'][0]['url'],
        pk: storyItems[i]['pk'],
        shortcode: storyItems[i]['code'],
        mediaType: storyItems[i]['media_type'],
        takenAt: storyItems[i]['taken_at'],
        posterUser: User(
          username: storyItems[i]['user']['username'],
          userID: storyItems[i]['user']['pk'],
          fullName: storyItems[i]['user']['full_name'],
          profilePic: storyItems[i]['user']['profile_pic_url'],
        ),
        hasMentions: hasMentions == null ? false : true,
        mentions: hasMentions != null ? mentions : null,
        videoURL: storyItems[i]['media_type'] == 2
            ? storyItems[i]['video_versions'][0]['url']
            : null,
      ));
    }
    return stories;
  }
}
