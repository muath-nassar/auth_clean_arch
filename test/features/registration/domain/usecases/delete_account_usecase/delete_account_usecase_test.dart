import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/delete_account_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../sign_up_usecase/sign_up_usecase_test.mocks.dart';

main() {
  late MockUserRepository mockUserRepository;
  late DeleteAccountUsecase usecase;
  late User testUser;
  String emailTest = 'test@test.com';
  String fNameTest = 'John';
  String lNameTest = 'Smith';
  late DateTime createdTimeTest;
  late DateTime lastLoginTest;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = DeleteAccountUsecase(mockUserRepository);
    lastLoginTest = DateTime.now();
    createdTimeTest = DateTime.now().subtract(const Duration(days: 2));
    testUser = User(
        id: 1,
        email: emailTest,
        firstName: fNameTest,
        lastName: lNameTest,
        createTime: createdTimeTest,
        lastLogin: lastLoginTest,
        emailVerified: true);
  });

  group("Green Scenario", () {
    test('should return the deleted user if delete success', () async {
      // Arrange
      when(mockUserRepository.getCurrentUserId())
          .thenAnswer((_) async => Right(testUser.id));
      when(mockUserRepository.deleteUser(any))
          .thenAnswer((_) async => Right(testUser));
      // Act
      var result = await usecase(NoParams());
      // Assert
      expect(result, Right(testUser));
      verify(mockUserRepository.getCurrentUserId());
      verify(mockUserRepository.deleteUser(testUser.id));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });

  group('Red Scenario', (){
    test('should return failure if getting current user id fails', () async {
      // Arrange
      when(mockUserRepository.getCurrentUserId())
          .thenAnswer((_)async=>const Left(DatabaseReadFailure([])));
      // Act
      var result = await usecase(NoParams());
      // Assert
      verify(mockUserRepository.getCurrentUserId());
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, const Left(DatabaseReadFailure([])));
    });
    test('should return failure if deleting current fails', () async {
      // Arrange
      when(mockUserRepository.getCurrentUserId())
          .thenAnswer((_)async=> Right(testUser.id));
      when(mockUserRepository.deleteUser(any))
          .thenAnswer((_)async=>const Left(DatabaseWriteFailure([])));
      // Act
      var result = await usecase(NoParams());
      // Assert
      verify(mockUserRepository.getCurrentUserId());
      verify(mockUserRepository.deleteUser(testUser.id));
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, const Left(DatabaseWriteFailure([])));
    });
  });
}
