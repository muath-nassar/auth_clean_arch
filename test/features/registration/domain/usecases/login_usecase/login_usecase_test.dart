import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/encryption.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/login_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../sign_up_usecase/sign_up_usecase_test.mocks.dart';
import 'login_usecase_test.mocks.dart';

@GenerateMocks([PasswordHashingUtil])
main() {

  late LoginUseCase useCase;
  late MockUserRepository mockUserRepository;
  late MockPasswordHashingUtil mockHashUtil;
  late User testUser;
  late User notVerifiedUserTest;
  String emailTest = 'test@test.com';
  String fNameTest = 'John';
  String lNameTest = 'Smith';
  String passwordTest = '1#4\$8gHsa1e4@DD';
  String encryptedPasswordTest = '1#4\$8gHsa1e4@DD';
  late DateTime createdTimeTest;
  late DateTime lastLoginTest;
  late LoginParams loginParams;
  late UserLoginCredentials loginCredentialsTest;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockHashUtil = MockPasswordHashingUtil();
    useCase =
        LoginUseCase(repository: mockUserRepository, hashUtil: mockHashUtil);
    createdTimeTest = DateTime.now();
    lastLoginTest = DateTime.now().subtract(const Duration(days: 2));
    testUser = User(
        id: 1,
        email: emailTest,
        firstName: fNameTest,
        lastName: lNameTest,
        createTime: createdTimeTest,
        lastLogin: lastLoginTest,
        emailVerified: true);
    notVerifiedUserTest = User(
        id: 1,
        email: emailTest,
        firstName: fNameTest,
        lastName: lNameTest,
        createTime: createdTimeTest,
        lastLogin: lastLoginTest,
        emailVerified: false);
    loginCredentialsTest = UserLoginCredentials(
        email: emailTest, encryptedPassword: encryptedPasswordTest);
  });
  loginParams = LoginParams(email: emailTest, password: passwordTest);

  group('Green Scenario', () {
    test('should return User if the authentication succeeded', () async {
      // Arrange
      when(mockHashUtil.verifyPassword(any, any)).thenAnswer((_) => true);
      when(mockUserRepository.getUserAuthCredentials(emailTest))
          .thenAnswer((_) async => Right(loginCredentialsTest));
      when(mockUserRepository.getUserByEmail(any))
          .thenAnswer((_) async => Right(testUser));
      when(mockUserRepository.cacheCurrentUser(any))
          .thenAnswer((_)async=>const Right(1));
      // Act
      var result = await useCase(loginParams);
      // Assert
      expect(result, Right(testUser));
      verify(mockUserRepository.getUserAuthCredentials(emailTest));
      verify(mockHashUtil.verifyPassword(passwordTest, encryptedPasswordTest));
      verify(mockUserRepository.getUserByEmail(emailTest));
      verifyNoMoreInteractions(mockHashUtil);
      verify(mockUserRepository.cacheCurrentUser(testUser.id));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });

  group('Red Scenario', () {
    test('''should return UserNotFoundFailure when the email
        provided doesn't exist ''', () async {
      // Arrange
      when(mockUserRepository.getUserAuthCredentials(emailTest))
          .thenAnswer((_) async => const Left(UserNotFoundFailure([])));
      // Act
      var result = await useCase(loginParams);
      // Assert
      expect(result, const Left(UserNotFoundFailure([])));
      verify(mockUserRepository.getUserAuthCredentials(emailTest));
      verifyNoMoreInteractions(mockUserRepository);
      verifyZeroInteractions(mockHashUtil);
    });

    test('''should return UserNotFoundFailure when the email
        provided exists but for any reason the getUserByEmail fails  ''', () async {
      // Arrange
      when(mockUserRepository.getUserAuthCredentials(emailTest))
          .thenAnswer((_) async => Right(loginCredentialsTest));
      when(mockHashUtil.verifyPassword(any, any))
          .thenAnswer((_) => true);
      when(mockUserRepository.getUserByEmail(any))
          .thenAnswer((_)async => const Left(UserNotFoundFailure([])));

      // Act
      var result = await useCase(loginParams);
      // Assert
      expect(result, const Left(UserNotFoundFailure([])));
      verify(mockUserRepository.getUserAuthCredentials(emailTest));
      verify(mockHashUtil.verifyPassword(passwordTest, encryptedPasswordTest));
      verify(mockUserRepository.getUserByEmail(emailTest));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('''should return WrongCredentials when the password doesn't match''',
            () async {
      // Arrange
      when(mockUserRepository.getUserAuthCredentials(any))
          .thenAnswer((_) async => Right(loginCredentialsTest));
      when(mockHashUtil.verifyPassword(any, any))
          .thenAnswer((_)=>false);
      when(mockUserRepository.getUserByEmail(any))
          .thenAnswer((_) async => const Left(WrongCredentialsFailure([])));
      // Act
      var result = await useCase(loginParams);
      // Assert
      expect(result, const Left(WrongCredentialsFailure(['Please check your provided email and password.'])));
      verify(mockUserRepository.getUserAuthCredentials(emailTest));
      verify(mockHashUtil.verifyPassword(passwordTest, encryptedPasswordTest));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('''should return EmailNotVerifiedFailure when email is not verified''',
            () async {
          // Arrange

          when(mockUserRepository.getUserAuthCredentials(any))
              .thenAnswer((_) async => Right(loginCredentialsTest));
          when(mockHashUtil.verifyPassword(any, any))
              .thenAnswer((_)=>true);
          when(mockUserRepository.getUserByEmail(any))
              .thenAnswer((_) async => Right(notVerifiedUserTest));
          // Act
          var result = await useCase(loginParams);
          // Assert
          expect(result, const Left(EmailNotVerifiedFailure(['test@test.com is not verified.'])));
          verify(mockUserRepository.getUserAuthCredentials(emailTest));
          verify(mockHashUtil.verifyPassword(passwordTest, encryptedPasswordTest));
          verify(mockUserRepository.getUserByEmail(emailTest));
          verifyNoMoreInteractions(mockUserRepository);
        });

    test('''should return CacheFailure if caching the user id fails''',
            () async {
          // Arrange

          when(mockUserRepository.getUserAuthCredentials(any))
              .thenAnswer((_) async => Right(loginCredentialsTest));
          when(mockHashUtil.verifyPassword(any, any))
              .thenAnswer((_)=>true);
          when(mockUserRepository.getUserByEmail(any))
              .thenAnswer((_) async => Right(testUser));
          when(mockUserRepository.cacheCurrentUser(any))
              .thenAnswer((_)async=>const Left(CacheFailure([])));
          // Act
          var result = await useCase(loginParams);
          // Assert
          expect(result, const Left(CacheFailure([])));
          verify(mockUserRepository.getUserAuthCredentials(emailTest));
          verify(mockHashUtil.verifyPassword(passwordTest, encryptedPasswordTest));
          verify(mockUserRepository.getUserByEmail(emailTest));
          verify(mockUserRepository.cacheCurrentUser(testUser.id));
          verifyNoMoreInteractions(mockUserRepository);
        });

  });


}
