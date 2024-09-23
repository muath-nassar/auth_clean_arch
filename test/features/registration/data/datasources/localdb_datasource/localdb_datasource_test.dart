import 'package:auth_clean_arch/core/database/database.dart' as db;
import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/local_db_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_create_model.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_login_credentials_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'localdb_datasource_test.mocks.dart';

@GenerateMocks([db.AppDatabase])
main() {
  late MockAppDatabase mockDatabase;
  late UserModelLocalDbDatasource datasource;
  late UserCreateModel userCreateModelTest;
  late UserLoginCredentialsModel loginCredentialsModel;

  setUp(() {
    mockDatabase = MockAppDatabase();
    datasource = UserModelLocalDbDatasourceImpl(db: mockDatabase);
    userCreateModelTest = const UserCreateModel(
      email: 'test@test.com',
      firstName: 'firstName',
      lastName: 'lastName',
      password: 'password',
    );
    loginCredentialsModel = const UserLoginCredentialsModel(
        email: 'test@test.com', encryptedPassword: 'hashPassword');
  });

  group('Create new User', () {
    test('should call insertUser', () async {
      // Arrange
      when(mockDatabase.insertUser(any)).thenAnswer((_) async => 1);
      // Act
      await datasource.createUser(userCreateModelTest);
      // Assert
      verify(mockDatabase.insertUser(any));
    });
  });

  test('should throw exception if not found using id', () async {
    // Arrange
    when(mockDatabase.getUser(any)).thenAnswer((_) async => null);
    // Act
    var call = datasource.getUserById;
    // Assert
    expect(() => call(1), throwsA(const TypeMatcher<UserNotFoundException>()));
  });
  test('should throw exception if not found using email', () async {
    // Arrange
    when(mockDatabase.getUserByEmail(any)).thenAnswer((_) async => null);
    // Act
    var call = datasource.getUserByEmail;
    // Assert
    expect(() => call(''), throwsA(const TypeMatcher<UserNotFoundException>()));
  });

  group('getLoginCredentials', () {
    DateTime? lastLogin = DateTime.now();
    DateTime createTime = lastLogin.subtract(const Duration(days: 50));
    String emailTest = 'test@test.com';
    db.User testUser = db.User(
        id: 1,
        email: emailTest,
        hashPassword: 'hashPassword',
        firstName: 'firstName',
        lastName: 'lastName',
        createTime: createTime,
        lastLogin: lastLogin,
        emailVerified: true);

    void mockGoodScenario(){
      when(mockDatabase.getUserByEmail(any)).thenAnswer((_) async => testUser);
    }
    void mockBadScenario(){
      when(mockDatabase.getUserByEmail(any)).thenAnswer((_) async => null);
    }


    test('should call the database and return the UserCredentials', () async {
      // Arrange
      mockGoodScenario();
      // Act
      var result = await datasource.getLoginCredentials(testUser.email);
      // Assert
      verify(mockDatabase.getUserByEmail(testUser.email));
      expect(result, loginCredentialsModel);
    });

    test('should throw Exception UserNotFoundException', () async {
      // Arrange
      mockBadScenario();
      // Act
      var call = datasource.getLoginCredentials;
      // Assert
      expect(()=>call(testUser.email), throwsA(const TypeMatcher<UserNotFoundException>()));
    });
  });
}
