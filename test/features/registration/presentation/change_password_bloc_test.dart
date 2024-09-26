import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/validators/email_validator.dart';
import 'package:auth_clean_arch/core/utils/validators/password_validator.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/forget_password_use_case.dart';
import 'package:auth_clean_arch/features/registration/presentation/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_bloc_test.mocks.dart';

@GenerateMocks([EmailValidator, PasswordValidator, ForgetPasswordUseCase])
void main() {
  late MockEmailValidator mockEmailValidator;
  late MockPasswordValidator mockPasswordValidator;
  late MockForgetPasswordUseCase mockForgetPasswordUseCase;
  late ChangePasswordBloc bloc;

  const String email = 'test@test.com';
  const String code = 'code';
  const String newPassword = 'newPassword';

  setUp(() {
    mockPasswordValidator = MockPasswordValidator();
    mockEmailValidator = MockEmailValidator();
    mockForgetPasswordUseCase = MockForgetPasswordUseCase();
    bloc = ChangePasswordBloc(
        emailValidator: mockEmailValidator,
        passwordValidator: mockPasswordValidator,
        useCase: mockForgetPasswordUseCase);
  });

  group('Send Code', () {
    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'should send the code',
      build: () => bloc,
      act: (bloc) {
        when(mockEmailValidator.validate(any)).thenAnswer((_) => Right(email));
        when(mockForgetPasswordUseCase.sendEmail(any))
            .thenAnswer((_) async => Right(code));
        bloc.add(SendEmail(email));
      },
      expect: () => <ChangePasswordState>[
        SendingState(),
        SendSuccessState(),
      ],
    );
    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'should invalidate email',
      build: () => bloc,
      act: (bloc) {
        when(mockEmailValidator.validate(any))
            .thenAnswer((_) => const Left(InvalidInputFailure([])));
        when(mockForgetPasswordUseCase.sendEmail(any))
            .thenAnswer((_) async => Right(code));
        bloc.add(SendEmail(email));
      },
      expect: () => <ChangePasswordState>[
        const InvalidEmailState(InvalidInputFailure([])),
      ],
    );
    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'email sending has errors',
      build: () => bloc,
      act: (bloc) {
        when(mockEmailValidator.validate(any)).thenAnswer((_) => const Right(email));
        when(mockForgetPasswordUseCase.sendEmail(any))
            .thenAnswer((_) async => const Left(EmailFailure([])));
        bloc.add(const SendEmail(email));
      },
      expect: () => <ChangePasswordState>[
        SendingState(),
        const SendErrorState(EmailFailure([])),
      ],
    );
  });

  group('Change password', (){
    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'should change the password',
      build: () => bloc,
      act: (bloc) {
        when(mockPasswordValidator.validate(any)).thenAnswer((_)=>const Right(newPassword));
        when(mockForgetPasswordUseCase.updatePassword(any, any)).thenAnswer((_)async=>const Right(newPassword));
        bloc.add(const ChangePasswordRequest(newPassword,code));
      },
      expect: () => <ChangePasswordState>[
        const ChangePasswordSuccessState(newPassword),
      ],
    );
  });
}
