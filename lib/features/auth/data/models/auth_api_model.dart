import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? password;
  final String? confirmPassword;
  final String? profilePicture;

  AuthApiModel({
    this.authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.profilePicture,
    this.password,
    this.confirmPassword,
  });

  /// info: From JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      authId: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      username: json["username"],
      profilePicture: json["profilePicture"],
    );
  }

  // info: To JSON
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "username": username,
      "password": password,
      "confirmPassword": confirmPassword,
      "profilePicture": profilePicture,
    };
  }

  // info: To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      profilePicture: profilePicture,
    );
  }

  /// info: From Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      authId: entity.authId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      username: entity.username,
      profilePicture: entity.profilePicture,
    );
  }
}
