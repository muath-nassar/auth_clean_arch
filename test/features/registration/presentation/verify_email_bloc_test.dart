import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/validators/email_validator.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/verify_email_use_case.dart';
import 'package:auth_clean_arch/features/registration/presentation/bloc/verify_email_bloc/verify_email_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'verify_email_bloc_test.mocks.dart';

@GenerateMocks([VerifyEmailUseCase, EmailValidator])
void main() {
  late MockEmailValidator mockEmailValidator;
  late MockVerifyEmailUseCase mockVerifyEmailUseCase;
  late VerifyEmailBloc bloc;

  DateTime createTime = DateTime.now();
  DateTime? lastLogin;
  User user = User(
      id: 1,
      email: 'test@test.com',
      firstName: 'firstName',
      lastName: 'lastName',
      createTime: createTime,
      lastLogin: lastLogin,
      emailVerified: true);

  setUp(() {
    mockEmailValidator = MockEmailValidator();
    mockVerifyEmailUseCase = MockVerifyEmailUseCase();
    bloc = VerifyEmailBloc(
        emailValidator: mockEmailValidator,
        verifyEmailUseCase: mockVerifyEmailUseCase);

  });


  group('Sending Event', (){
    const String emailTest = 'test@test.com';
    const String code = '12345';

    Either<Failure, String> emailValidationSuccess = const Right(emailTest);
    Either<Failure, String> emailValidationFailure = const Left(InvalidInputFailure([]));
    Either<Failure, String> verifyingUseCaseSuccess = const Right(code);
    Either<Failure, String> verifyingUseCaseFailure = const Left(EmailFailure(([])));
    
    void mockSendEmail({
      emailValid = true,
      useCaseValid = true, // Specify types explicitly
    })async {
      when(mockEmailValidator.validate(any)).thenAnswer((_) => emailValid ? emailValidationSuccess : emailValidationFailure);
      when(mockVerifyEmailUseCase.sendEmail(any)).thenAnswer((_) async => useCaseValid? verifyingUseCaseSuccess : verifyingUseCaseFailure);
    }

    blocTest<VerifyEmailBloc, VerifyEmailState>(
      'should send the email',
      build: () =>bloc,
      act: (bloc) {
        mockSendEmail();
        // when(mockEmailValidator.validate(any)).thenAnswer((_) => const Right(emailTest));
        // when(mockVerifyEmailUseCase.sendEmail(any)).thenAnswer((_) async => const Right(code));
        bloc.add(const SendEmailEvent(emailTest));
      },
      expect: () => <VerifyEmailState>[
        Sending(),
        SendSuccess(),
      ],
    );

    blocTest<VerifyEmailBloc, VerifyEmailState>(
      'should invalidate the email',
      build: () =>bloc,
      act: (bloc) {

        mockSendEmail(emailValid: false);
        bloc.add(const SendEmailEvent(emailTest));
      },
      expect: () => <VerifyEmailState>[
        const InvalidEmail(InvalidInputFailure([]))
      ],
    );

    blocTest<VerifyEmailBloc, VerifyEmailState>(
      'fail to send email',
      build: () =>bloc,
      act: (bloc) {

        mockSendEmail(useCaseValid: false);
        bloc.add(const SendEmailEvent(emailTest));
      },
      expect: () => <VerifyEmailState>[
        Sending(),
        const SendError(EmailFailure([]))
      ],
    );


  });
  
  group('Verify Code Event', (){
    void mockCodeVerification({verified = true}){
      when(mockVerifyEmailUseCase.verifyEmail(any)).thenAnswer((_) async=>
      verified ? Right(user) : const Left(VerificationCodeFailure([])));
    }
    String code = '12345';
    blocTest<VerifyEmailBloc, VerifyEmailState>(
      'should return the user',
      build: () =>bloc,
      act: (bloc) {
        mockCodeVerification();
        bloc.add(VerifyCodeEvent(code));
      },
      expect: () => <VerifyEmailState>[
        VerifiedEmail()
      ],
    );    
    blocTest<VerifyEmailBloc, VerifyEmailState>(
      'should return failure',
      build: () =>bloc,
      act: (bloc) {
        mockCodeVerification(verified: false);
        bloc.add(VerifyCodeEvent(code));
      },
      expect: () => <VerifyEmailState>[
        const UnverifiedEmail(VerificationCodeFailure([]))
      ],
    );
  });
}
