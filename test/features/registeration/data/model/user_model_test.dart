import 'dart:convert';

import 'package:auth_clean_arch/features/registration/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  UserModel testUser = UserModel(
      id: 1,
      email: 'test@test.com',
      firstName: 'John',
      lastName: 'Doe');
  group('fromJson', () {
    test('should return a valid model', () async {
      // arrange
      Map<String, dynamic> jsonMap = jsonDecode(fixture('user_json.json'));

      // act
      var result = UserModel.fromJson(jsonMap);

      // assert
      expect(result, testUser);
    });
  });

  group('toJson', () {
    test('should return a valid Json', () async {
      // act
      var result = testUser.toJson();

      // assert
      expect(result, {
        "id": 1,
        "email": "test@test.com",
        "firstName": "John",
        "lastName": "Doe"
      });
    });
  });
}
