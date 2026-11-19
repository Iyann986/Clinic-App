import 'package:clinic_app/app/data/models/user_model.dart';

/// Bentuk `data` pada response `/api/login`, `/api/login/google`, dan
/// `/api/google-login`:
/// ```json
/// { "token": "...", "user": { ... }, "is_new": false }
/// ```
class LoginModel {
  final String? token;
  final UserModel? user;
  final bool? isNew;

  LoginModel({this.token, this.user, this.isNew});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    token: json['token'],
    isNew: json['is_new'],
    user: json['user'] == null ? null : UserModel.fromJson(json['user']),
  );
}
