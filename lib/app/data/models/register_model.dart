import 'package:clinic_app/app/data/models/user_model.dart';

/// Bentuk `data` pada response `POST /api/register`:
/// ```json
/// {
///   "user": { ... },
///   "is_new": true,
///   "access_token": "...",
///   "access_token_expires_at": "...",
///   "refresh_token": "...",
///   "refresh_token_expires_at": "...",
///   "token_type": "Bearer"
/// }
/// ```
class RegisterModel {
  final UserModel? user;
  final bool? isNew;
  final String? accessToken;
  final String? accessTokenExpiresAt;
  final String? refreshToken;
  final String? refreshTokenExpiresAt;
  final String? tokenType;

  RegisterModel({
    this.user,
    this.isNew,
    this.accessToken,
    this.accessTokenExpiresAt,
    this.refreshToken,
    this.refreshTokenExpiresAt,
    this.tokenType,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    user: json['user'] == null ? null : UserModel.fromJson(json['user']),
    isNew: json['is_new'],
    accessToken: json['access_token'],
    accessTokenExpiresAt: json['access_token_expires_at'],
    refreshToken: json['refresh_token'],
    refreshTokenExpiresAt: json['refresh_token_expires_at'],
    tokenType: json['token_type'],
  );
}
