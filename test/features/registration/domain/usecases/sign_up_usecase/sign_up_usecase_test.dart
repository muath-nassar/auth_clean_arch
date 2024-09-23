import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/encryption.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/sign_up_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../login_usecase/login_usecase_test.mocks.dart';
import 'sign_up_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])
main() {
  late MockUserRepository mockUserRepository;
  late SignUpUseCase useCase;
  late MockPasswordHashingUtil mockPasswordHashingUtil;
  late User testUser;
  String emailTest = 'test@test.com';
  String fNameTest = 'John';
  String lNameTest = 'Smith';
  late DateTime createdTimeTest;
  late UserCreateParams newUserParams;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockPasswordHashingUtil = MockPasswordHashingUtil();
    useCase = SignUpUseCase(mockUserRepository, mockPasswordHashingUtil);
    createdTimeTest = DateTime.now();
    testUser = User(
        id: 1,
        email: emailTest,
        firstName: fNameTest,
        lastName: lNameTest,
        createTime: createdTimeTest,
        lastLogin: null,
        emailVerified: false);
    newUserParams = UserCreateParams(
    email: emailTest,
    firstName: fNameTest,
    lastName: lNameTest,
    password: '1234*&Abs');
  });

  group('green scenario, should success', () {
    test('should return User if success', () async {
      // arrange
      when(mockUserRepository.createUser(any))
          .thenAnswer((_) async => Right(testUser));
      when(mockPasswordHashingUtil.hash(any))
          .thenAnswer((_)=>'1234*&Abs');
      // act
      var result = await useCase(newUserParams);
      // assert
      expect(result, Right(testUser));
    });
  });

  group("shouldn't success, Failure expected", (){
    UserCreateFailure failure =
    UserCreateFailure(['$emailTest already exists']);
    test('should return UserCreateFailure', () async {
      // arrange
      when(mockUserRepository.createUser(any))
          .thenAnswer((_) async => Left(failure));
      when(mockPasswordHashingUtil.hash(any))
          .thenAnswer((_)=>'1234*&Abs');
      // act
      var result = await useCase(newUserParams);
      // assert
      expect(result, Left(failure));
    });
  });
}