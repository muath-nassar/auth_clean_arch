import 'package:auth_clean_arch/core/database/database.dart';
import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/local_db_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_create_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'localdb_datasource_test.mocks.dart';

@GenerateMocks([AppDatabase])
main() {
  late MockAppDatabase mockDatabase;
  late UserModelLocalDbDatasource datasource;
  late UserCreateModel userCreateModelTest;

  setUp(() {
    mockDatabase = MockAppDatabase();
    datasource = UserModelLocalDbDatasourceImpl(db: mockDatabase);
    userCreateModelTest = const UserCreateModel(
        email: 'test@test.com',
        firstName: 'firstName',
        lastName: 'lastName',
        password: 'password',
    );
  });

  group('Create new User', () {
    test('should call insertUser', () async {
      // Arrange
      when(mockDatabase.insertUser(any)).thenAnswer((_)async=>1);
      // Act
      await datasource.createUser(userCreateModelTest);
      // Assert
      verify(mockDatabase.insertUser(any));
    });
  });
  test('should throw exception if not found using id', () async {
    // Arrange
    when(mockDatabase.getUser(any)).thenAnswer((_)async=>null);
    // Act
    var call = datasource.getUserById;
    // Assert
    expect(()=>call(1), throwsA(const TypeMatcher<UserNotFoundException>()));
  });
  test('should throw exception if not found using email', () async {
    // Arrange
    when(mockDatabase.getUserByEmail(any)).thenAnswer((_)async=>null);
    // Act
    var call = datasource.getUserByEmail;
    // Assert
    expect(()=>call(''), throwsA(const TypeMatcher<UserNotFoundException>()));
  });

}