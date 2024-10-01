import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/local_user_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/remote_user_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_model.dart';
import 'package:auth_clean_arch/features/registration/data/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_test.mocks.dart';


// Generating mock classes for dependencies
@GenerateMocks([RemoteUserDataSource, LocalUserDatasource])
void main() {

  late MockRemoteUserDataSource mockRemoteUserDataSource;
  late MockLocalUserDatasource mockLocalUserDataSource;
  late UserRepository repository;

  // Setting up test data
  const String testEmail = 'test@example.com';
  const String testPassword = 'password123';
  UserModel testUser = UserModel(id: 1, email: testEmail, firstName: 'John', lastName: 'Doe');

  setUp(() {
    mockRemoteUserDataSource = MockRemoteUserDataSource();
    mockLocalUserDataSource = MockLocalUserDatasource();
    repository = UserRepositoryImp(
        remoteUserDataSource: mockRemoteUserDataSource,
        localUserDatasource: mockLocalUserDataSource
    );
  });

  group('Login Use Case', () {
    test('should return user and cache it on successful login', () async {
      // Arrange
      when(mockRemoteUserDataSource.login(testEmail, testPassword))
          .thenAnswer((_) async => testUser);
      when(mockLocalUserDataSource.cacheCurrentUser(any))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.login(testEmail, testPassword);

      // Assert
      expect(result, Result<User>.success(testUser));
      verify(mockRemoteUserDataSource.login(testEmail, testPassword));
      verify(mockLocalUserDataSource.cacheCurrentUser(testUser));
    });




    test('should return NetworkFailure on NetworkException', () async {
      // Arrange
      when(mockRemoteUserDataSource.login(testEmail, testPassword))
          .thenThrow(NetworkException());

      // Act
      final result = await repository.login(testEmail, testPassword);

      // Assert
      expect(result, Result<User>.failure(const NetworkFailure(['Internet connection is down'])));
      verify(mockRemoteUserDataSource.login(testEmail, testPassword));
      verifyNever(mockLocalUserDataSource.cacheCurrentUser(any));
    });

    test('should return WrongCredentialsFailure on LoginException', () async {
      // Arrange
      when(mockRemoteUserDataSource.login(testEmail, testPassword))
          .thenThrow(LoginException());

      // Act
      final result = await repository.login(testEmail, testPassword);

      // Assert
      expect(result, Result<User>.failure(const WrongCredentialsFailure(['Invalid email or password'])));
      verify(mockRemoteUserDataSource.login(testEmail, testPassword));
      verifyNever(mockLocalUserDataSource.cacheCurrentUser(any));
    });

    test('should return FormatFailure on FormatException', () async {
      // Arrange
      when(mockRemoteUserDataSource.login(testEmail, testPassword))
          .thenThrow(const FormatException());

      // Act
      final result = await repository.login(testEmail, testPassword);

      // Assert
      expect(result, Result<User>.failure(const FormatFailure(['Invalid user json'])));
      verify(mockRemoteUserDataSource.login(testEmail, testPassword));
      verifyNever(mockLocalUserDataSource.cacheCurrentUser(any));
    });


  });

  group('Logout Use Case', () {
    test('should delete current user and return success result', () async {
      // Arrange
      when(mockLocalUserDataSource.deleteCurrentUser())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, Result<void>.success(null));
      verify(mockLocalUserDataSource.deleteCurrentUser());
    });

  });

  group('Get Current User', () {
    test('should return current user when one is cached', () async {
      // Arrange
      when(mockLocalUserDataSource.getLastCachedUser())
          .thenAnswer((_) async => testUser);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, Result<User>.success(testUser));
    });

    test('should return NoCachedUserFailure when no user is cached', () async {
      // Arrange
      when(mockLocalUserDataSource.getLastCachedUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, Result<User>.failure(const NoCachedUserFailure([])));
    });
  });


  group('Delete User', () {
    test('should return success when user is deleted successfully', () async {
      // Arrange
      when(mockRemoteUserDataSource.deleteUser(any))
          .thenAnswer((_) async => testUser); // Adjust this if returning void

      // Act
      final result = await repository.deleteUser(testUser.id!);

      // Assert
      expect(result, Result<User>.success(testUser)); // Adjust if returning User
      verify(mockRemoteUserDataSource.deleteUser(testUser.id));
    });

    test('should return NetworkFailure when NetworkException is thrown', () async {
      // Arrange
      when(mockRemoteUserDataSource.deleteUser(any))
          .thenThrow(NetworkException());

      // Act
      final result = await repository.deleteUser(testUser.id!);

      // Assert
      expect(result, Result<User>.failure(const NetworkFailure(['Internet connection is down'])));
      verify(mockRemoteUserDataSource.deleteUser(testUser.id));
    });

    test('should return ServerFailure when ServerException is thrown', () async {
      // Arrange
      when(mockRemoteUserDataSource.deleteUser(any))
          .thenThrow(ServerException());

      // Act
      final result = await repository.deleteUser(testUser.id!);

      // Assert
      expect(result, Result<User>.failure(ServerFailure(['can\'t delete the user ${testUser.id}'])));
      verify(mockRemoteUserDataSource.deleteUser(testUser.id));
    });
  });


  group('getUser', () {
    const int testUserId = 1;
    final UserModel testUser = UserModel(id: testUserId, email: 'test@example.com', firstName: 'John', lastName: 'Doe');

    test('should return a user on successful retrieval', () async {
      // Arrange
      when(mockRemoteUserDataSource.getUser(testUserId)).thenAnswer((_) async => testUser);

      // Act
      final result = await repository.getUser(testUserId);

      // Assert
      expect(result, Result<User>.success(testUser));
      verify(mockRemoteUserDataSource.getUser(testUserId));
    });

    test('should return NetworkFailure on NetworkException', () async {
      // Arrange
      when(mockRemoteUserDataSource.getUser(testUserId)).thenThrow(NetworkException());

      // Act
      final result = await repository.getUser(testUserId);

      // Assert
      expect(result, Result<User>.failure(const NetworkFailure(['Internet connection is down'])));
      verify(mockRemoteUserDataSource.getUser(testUserId));
    });

    test('should return FormatFailure on FormatException', () async {
      // Arrange
      when(mockRemoteUserDataSource.getUser(testUserId)).thenThrow(const FormatException());

      // Act
      final result = await repository.getUser(testUserId);

      // Assert
      expect(result, Result<User>.failure(const FormatFailure(['Invalid user json'])));
      verify(mockRemoteUserDataSource.getUser(testUserId));
    });

    test('should return ServerFailure on ServerException', () async {
      // Arrange
      when(mockRemoteUserDataSource.getUser(testUserId)).thenThrow(ServerException());

      // Act
      final result = await repository.getUser(testUserId);

      // Assert
      expect(result, Result<User>.failure(const ServerFailure(['Unable to retrieve user with id: $testUserId'])));
      verify(mockRemoteUserDataSource.getUser(testUserId));
    });
  });


  group('changePassword', () {
    const int testUserId = 1;
    const String newPassword = 'newPassword123';

    test('should return true on successful password change', () async {
      // Arrange
      when(mockRemoteUserDataSource.changePassword(testUserId, newPassword)).thenAnswer((_) async => true);

      // Act
      final result = await repository.changePassword(testUserId, newPassword);

      // Assert
      expect(result, Result<bool>.success(true));
      verify(mockRemoteUserDataSource.changePassword(testUserId, newPassword));
    });

    test('should return ServerFailure on ServerException', () async {
      // Arrange
      when(mockRemoteUserDataSource.changePassword(testUserId, newPassword)).thenThrow(ServerException());

      // Act
      final result = await repository.changePassword(testUserId, newPassword);

      // Assert
      expect(result, Result<bool>.failure(const ServerFailure(['Server Error'])));
      verify(mockRemoteUserDataSource.changePassword(testUserId, newPassword));
    });
  });


  group('updateUser', () {
    const int testUserId = 1;
    UserModel updatedUser = UserModel(id: 1, email: 'updated@example.com', firstName: 'Jane', lastName: 'Doe');

    test('should return updated user and cache it on successful update', () async {
      // Arrange
      when(mockRemoteUserDataSource.updateUser(testUserId, updatedUser)).thenAnswer((_) async => updatedUser);
      when(mockLocalUserDataSource.cacheCurrentUser(any)).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.updateUser(testUserId, updatedUser);

      // Assert
      expect(result, Result<User>.success(updatedUser));
      verify(mockRemoteUserDataSource.updateUser(testUserId, updatedUser));
      verify(mockLocalUserDataSource.cacheCurrentUser(updatedUser));
    });

    test('should return NetworkFailure on NetworkException', () async {
      // Arrange
      when(mockRemoteUserDataSource.updateUser(testUserId, updatedUser)).thenThrow(NetworkException());

      // Act
      final result = await repository.updateUser(testUserId, updatedUser);

      // Assert
      expect(result, Result<User>.failure(const NetworkFailure(['Internet connection is down'])));
      verify(mockRemoteUserDataSource.updateUser(testUserId, updatedUser));
      verifyNever(mockLocalUserDataSource.cacheCurrentUser(any));
    });

    test('should return FormatFailure on FormatException', () async {
      // Arrange
      when(mockRemoteUserDataSource.updateUser(testUserId, updatedUser)).thenThrow(FormatException());

      // Act
      final result = await repository.updateUser(testUserId, updatedUser);

      // Assert
      expect(result, Result<User>.failure(const FormatFailure(['Invalid user json'])));
      verify(mockRemoteUserDataSource.updateUser(testUserId, updatedUser));
      verifyNever(mockLocalUserDataSource.cacheCurrentUser(any));
    });

    test('should return ServerFailure on ServerException', () async {
      // Arrange
      when(mockRemoteUserDataSource.updateUser(testUserId, updatedUser)).thenThrow(ServerException());

      // Act
      final result = await repository.updateUser(testUserId, updatedUser);

      // Assert
      expect(result, Result<User>.failure(const ServerFailure(['Server error'])));
      verify(mockRemoteUserDataSource.updateUser(testUserId, updatedUser));
      verifyNever(mockLocalUserDataSource.cacheCurrentUser(any));
    });
  });


}
