import 'package:instagram_mentions/models/story.dart';
import 'package:instagram_mentions/models/user.dart';

class GetStoriesResponse {
  final bool isSuccess;
  final List<Story> stories;
  final String errorMsg;
  GetStoriesResponse({this.errorMsg, this.isSuccess, this.stories});
}
