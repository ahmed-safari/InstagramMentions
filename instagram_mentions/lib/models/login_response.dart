import 'package:instagram_mentions/models/logged_user.dart';

class LoginResponse {
  final bool isSuccess;
  final LoggedUser userData;
  final String errorMsg;
  LoginResponse({this.isSuccess, this.errorMsg, this.userData});
}
