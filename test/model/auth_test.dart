import 'package:flutter_test/flutter_test.dart';
import 'package:vedaverse/features/auth/data/models/auth_api_model.dart';
import 'package:vedaverse/features/auth/data/models/auth_hive_model.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';

// hack: flutter test --coverage
// hack: flutter pub run test_cov_console
void main() {
  group("Entity and Hive Model conversion", () {
    test('convert to entity from hive model', () {
      final authModel = AuthHiveModel(
        authId: "id101",
        firstName: "test",
        email: "test@gmail.com",
        username: "username",
        lastName: "lastName",
      );

      AuthEntity expectedEntity = AuthEntity(
        authId: "id101",
        firstName: "test",
        lastName: "lastName",
        email: "test@gmail.com",
        username: "username",
      );
      AuthEntity actualEntity = authModel.toEntity();

      expect(expectedEntity, actualEntity);
    });

    test("convert to hive model from entity", () {
      final authEntity = AuthEntity(
        authId: "id102",
        firstName: "firstName",
        lastName: "lastName",
        email: "email@email.com",
        username: "username",
      );

      AuthHiveModel expectedModel = AuthHiveModel(
        authId: "id102",
        firstName: "firstName",
        lastName: "lastName",
        email: "email@email.com",
        username: "username",
      );
      AuthHiveModel actualModel = AuthHiveModel.fromEntity(authEntity);

      expect(actualModel.authId, expectedModel.authId);
      expect(actualModel.firstName, expectedModel.firstName);
      expect(actualModel.lastName, expectedModel.lastName);
      expect(actualModel.email, expectedModel.email);
      expect(actualModel.username, expectedModel.username);
    });
  });

  group("Json and Api Model conversion", () {
    test("convert from Json to Api model", () {
      Map<String, dynamic> json = {
        "_id": "id103",
        "firstName": "firstName",
        "lastName": "lastName",
        "email": "email@email.com",
        "username": "username",
      };

      final expectedModel = AuthApiModel(
        authId: "id103",
        firstName: "firstName",
        email: "email@email.com",
        username: "username",
        lastName: "lastName",
      );

      AuthApiModel actualModel = AuthApiModel.fromJson(json);

      expect(actualModel.authId, expectedModel.authId);
      expect(actualModel.firstName, expectedModel.firstName);
      expect(actualModel.lastName, expectedModel.lastName);
      expect(actualModel.email, expectedModel.email);
      expect(actualModel.username, expectedModel.username);
    });

    test("convert to json from Api model", () {
      final apiModel = AuthApiModel(
        firstName: "firstName",
        email: "email@email.com",
        username: "username",
        lastName: "lastName",
      );

      Map<String, dynamic> expectedJson = {
        "firstName": "firstName",
        "lastName": "lastName",
        "email": "email@email.com",
        "username": "username",
      };

      Map<String, dynamic> actualJson = apiModel.toJson();
      // expect(actualJson, expectedJson);
      expect(actualJson["firstName"], expectedJson["firstName"]);
      expect(actualJson["lastName"], expectedJson["lastName"]);
      expect(actualJson["email"], expectedJson["email"]);
      expect(actualJson["username"], expectedJson["username"]);
    });
  });

  test("convert to auth entity from Api model", () {
    final apiModel = AuthApiModel(
      authId: "id104",
      firstName: "firstName",
      email: "email@email.com",
      username: "username",
      lastName: "lastName",
    );

    AuthEntity expectedEntity = AuthEntity(
      authId: "id104",
      firstName: "firstName",
      lastName: "lastName",
      email: "email@email.com",
      username: "username",
    );

    AuthEntity actualEntity = apiModel.toEntity();

    expect(actualEntity, expectedEntity);
  });
}
