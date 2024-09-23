import 'package:auth_clean_arch/core/database/database.dart' as db;
import 'package:auth_clean_arch/features/registration/data/models/user_create_model.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_login_credentials_model.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_model.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late db.User dbUserTest;
  late UserModel userTest;
  late UserLoginCredentialsModel credentialsModel;
  late db.UsersCompanion usersCompanionTest;

  setUp(() {
    var now = DateTime.now();
    var before50Days = now.subtract(const Duration(days: 50));
    dbUserTest = db.User(
        id: 1,
        email: 'test@test.com',
        hashPassword: '8847387n3ji32***534',
        firstName: 'John',
        lastName: 'Smith',
        createTime: before50Days,
        lastLogin: now,
        emailVerified: true);

    usersCompanionTest = db.UsersCompanion(
        email: const Value('test@test.com'),
        firstName: const Value('John'),
        lastName: const Value('Smith'),
        createTime: Value(before50Days),
        lastLogin: Value(now),
        emailVerified: const Value(true));

    userTest = UserModel(
      id: 1,
      email: 'test@test.com',
      firstName: 'John',
      lastName: 'Smith',
      createTime: before50Days,
      lastLogin: now,
      emailVerified: true,
    );
    credentialsModel = const UserLoginCredentialsModel(
      email: 'test@test.com',
      encryptedPassword: '8847387n3ji32***534',
    );
  });

  group('UserModel', () {
    test('should return user from db model', () async {
      // Act
      var result = UserModel.fromDB(dbUserTest);
      // Assert
      expect(result, userTest);
      expect(result as User, result as User);
    });

    test('should return userCompanion correctly', () async {
      // Arrange

      // Act
      var result = userTest.toDB();
      // Assert
      expect(result, usersCompanionTest);
    });
  });
  group('UserLoginCredentialsModel', () {
    test('should return UserLoginCredentialsModel from db model', () async {
      // Arrange

      // Act
      var result = UserLoginCredentialsModel.fromDB(dbUserTest);
      // Assert
      expect(result, credentialsModel);
    });
  });

  group('UserCreateModel', () {
    test('should return a CompanionUser that matches the create', () async {
      // Arrange
      var userToCreate = const UserCreateModel(
          email: 'test@test.com',
          firstName: 'AA',
          lastName: 'BB',
          password: '1234567');
      // Act
      var result = userToCreate.toDB();

      // Assert
      var expected =  db.UsersCompanion(
        email: const Value('test@test.com'),
        firstName: const Value('AA'),
        lastName: const Value('BB'),
        hashPassword: const Value('1234567'),
        createTime: Value(DateTime.now()),
        lastLogin: const Value(null)
      );
      // Compare each field individually
      expect(result.email, expected.email);
      expect(result.firstName, expected.firstName);
      expect(result.lastName, expected.lastName);
      expect(result.hashPassword, expected.hashPassword);

      // Allow a 2-second range for the createTime comparison
      final createTimeDifference = result.createTime.value.difference(expected.createTime.value).inSeconds;
      expect(createTimeDifference.abs(), lessThanOrEqualTo(2));

      expect(result.lastLogin, expected.lastLogin);
      // expect(result,expected);
    });
  });
}
