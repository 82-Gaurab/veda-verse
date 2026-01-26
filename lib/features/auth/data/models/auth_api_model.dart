import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? password;
  final String? confirmPassword;
  // final String? batchId;
  final String? profilePicture;
  // final BatchApiModel? batch;

  AuthApiModel({
    this.authId,
    required this.firstName,
    required this.email,
    required this.username,
    this.password,
    this.profilePicture,
    this.confirmPassword,
    required this.lastName,
  });

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

  // info: from JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      authId: json["_id"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      email: json["email"] as String,
      username: json["username"] as String,
      profilePicture: json["profilePicture"] as String?,
    );
  }

  // info: to entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      firstName: firstName,
      email: email,
      username: username,
      profilePicture: profilePicture,
      lastName: lastName,
    );
  }

  // info: from entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      authId: entity.authId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      username: entity.username,
      profilePicture: entity.profilePicture,
    );
  }

  // info: to entity list
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
