
import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/services/email_service.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/verify_email_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../sign_up_usecase/sign_up_usecase_test.mocks.dart';
import 'verify_email_usecase_test.mocks.dart';
@GenerateMocks([VerificationEmailService])
main(){
  String codeTest = '123456';
  late MockUserRepository mockUserRepository;
  late MockVerificationEmailService mockMailService;
  
  late VerifyEmailUseCase usecase;
  late User testUser;
  mockMailService = MockVerificationEmailService();
  String emailTest = 'test@test.com';
  String fNameTest = 'John';
  String lNameTest = 'Smith';
  late DateTime createdTimeTest;
  late DateTime lastLoginTest;
  late EmailParams emailParamsTest;
  late VerificationMailParams verificationMailParams;


  setUp(() {
    mockMailService = MockVerificationEmailService();
    mockUserRepository = MockUserRepository();
    usecase = VerifyEmailUseCase(
        repository: mockUserRepository,
        verificationEmailService: mockMailService);
    lastLoginTest = DateTime.now();
    createdTimeTest = DateTime.now().subtract(const Duration(days: 2));
    testUser = User(
        id: 1,
        email: emailTest,
        firstName: fNameTest,
        lastName: lNameTest,
        createTime: createdTimeTest,
        lastLogin: lastLoginTest,
        emailVerified: false);
    emailParamsTest = EmailParams(email: testUser.email);
    verificationMailParams = VerificationMailParams(receiverEmail: testUser.email, code: codeTest);
  });
  
  group('Green Send Scenario', (){
    setUp((){
      when(mockUserRepository.getUserByEmail(any))
          .thenAnswer((_)async=>Right(testUser));
      when(mockMailService.call(any)).thenAnswer((_)async=>Right(codeTest));
    });
    test('should generate a random 6 digit code', () async {
      // Act
      await usecase(emailParamsTest);
      // Assert
      expect(usecase.verificationCode!.length, 6);
    });

    test('should have a user matches the email', () async {
      // Act
      await usecase(emailParamsTest);
      // Assert
      verify(mockUserRepository.getUserByEmail(emailTest));
    });
    test('should call send verification email', () async {
      // Act
      await usecase(emailParamsTest);
      // Assert
      verify(mockMailService.call(verificationMailParams));
    });

    test('should change time to current if send mail success', () async {
      // Act
      await usecase(emailParamsTest);
      // Assert
      var now = DateTime.now();
      expect(1 >= now.compareTo(usecase.sentTime!)
          && now.compareTo(usecase.sentTime!) >= 0, true);
    });
  });

  group(('Red send scenario'), (){
    test('should return failure if user is not found', () async {
      // Arrange
      when(mockUserRepository.getUserByEmail(any))
          .thenAnswer((_)async=>const Left(UserNotFoundFailure([])));
      // Act
      var result = await usecase(emailParamsTest);
      // Assert
      expect(result, const Left(UserNotFoundFailure([])));
      verify(mockUserRepository.getUserByEmail(emailTest));
      verifyZeroInteractions(mockMailService);
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return failure if sending the mail fails', () async {
      // Arrange
      when(mockUserRepository.getUserByEmail(any))
          .thenAnswer((_)async=>Right(testUser));
      when(mockMailService.call(any))
          .thenAnswer((_)async=>const Left(EmailFailure([])));
      // Act
      var result = await usecase(emailParamsTest);
      // Assert
      expect(result, const Left(EmailFailure([])));
    });

    test('should not send if the user try to resend within 5 minutes', () async {
      // Arrange
      when(mockUserRepository.getUserByEmail(any))
          .thenAnswer((_)async=>Right(testUser));
      when(mockMailService.call(any)).thenAnswer((_)async=>Right(codeTest));
      var now = DateTime.now();
      var before6minutes = now.subtract(const Duration(minutes: 6));
      usecase.sentTime = before6minutes;
      // Act
      var result = await usecase.sendEmail(emailParamsTest);
      // Assert
      expect(result, const Left(EmailFailure([])));
      verifyZeroInteractions(mockUserRepository);
      verifyZeroInteractions(mockMailService);

    });
  });

  //-------------


  group('verify code verifier in red scenarios', (){
    test('should return false if the there is no email sent', () async {
      // Arrange
      usecase.sentTime = null;
      // Act
      var result = usecase.verifyInputCode(codeTest);
      // Assert
      expect(result, false);
    });
    test('should return false if sent time is over 5 minutes', () async {
      // Arrange
      usecase.verificationCode = codeTest;
      var now = DateTime.now();
      var before6minutes = now.subtract(const Duration(seconds: 5*60 + 1));
      usecase.sentTime = before6minutes;
      // Act
      var result = usecase.verifyInputCode(codeTest);
      // Assert
      expect(result, false);
    });
    test('should return false if verification code does not match' , () async {
      // Arrange
      var now = DateTime.now();
      var before2minutes = now.subtract(const Duration(minutes: 2));
      usecase.verificationCode = codeTest;
      usecase.sentTime = before2minutes;
      usecase.verificationCode = '99999';

      usecase.sentTime = before2minutes;
      // Act
      var result = usecase.verifyInputCode(codeTest);
      // Assert
      expect(result, false);
    });
  });

  test('should return true if verification code match' , () async {
    // Arrange
    var now = DateTime.now();
    var before2minutes = now.subtract(const Duration(minutes: 2));
    usecase.verificationCode = codeTest;
    usecase.sentTime = before2minutes;
    // Act
    var result = usecase.verifyInputCode(codeTest);
    // Assert
    expect(result, true);
  });

  group('Verify Email action', (){
    test('should call update user verified to true for the user', () async {
      // Arrange
      var now = DateTime.now();
      var before2minutes = now.subtract(const Duration(minutes: 2));
      usecase.sentTime = before2minutes;
      usecase.verificationCode = codeTest;
      usecase.emailToVerify = testUser.email;
      var updatedUser = User(
          id: testUser.id,
          email: testUser.email,
          firstName: testUser.firstName,
          lastName: testUser.lastName,
          createTime: testUser.createTime,
          lastLogin: testUser.createTime,
          emailVerified: true
      );
      when(mockUserRepository.getUserByEmail(any))
          .thenAnswer((_)async=>Right(testUser));
      when(mockUserRepository.updateUser(updatedUser))
          .thenAnswer((_)async=>Right(updatedUser));
      // Act
      var result = await usecase.verifyEmail(codeTest);
      // Assert
      expect(result, Right(updatedUser));
      verify(mockUserRepository.getUserByEmail(testUser.email));
      verify(mockUserRepository.updateUser(updatedUser));
      verifyNoMoreInteractions(mockUserRepository);
      verifyZeroInteractions(mockMailService);
    });
    test('should return Failure if code is wrong', () async {
      // Arrange
      var now = DateTime.now();
      var before2minutes = now.subtract(const Duration(minutes: 2));
      usecase.sentTime = before2minutes;
      usecase.verificationCode = '999999';
      usecase.emailToVerify = testUser.email;
      var updatedUser = User(
          id: testUser.id,
          email: testUser.email,
          firstName: testUser.firstName,
          lastName: testUser.lastName,
          createTime: testUser.createTime,
          lastLogin: testUser.createTime,
          emailVerified: true
      );
      when(mockUserRepository.getUserByEmail(any))
          .thenAnswer((_)async=>Right(testUser));
      when(mockUserRepository.updateUser(updatedUser))
          .thenAnswer((_)async=>Right(updatedUser));
      // Act
      var result = await usecase.verifyEmail(codeTest);
      // Assert
      expect(result, const Left(VerificationCodeFailure([])));
      verifyZeroInteractions(mockUserRepository);

    });
  });

}