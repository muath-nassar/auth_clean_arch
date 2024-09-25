import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/validators/email_validator.dart';
import 'package:auth_clean_arch/core/utils/validators/password_validator.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/login_use_case.dart';
import 'package:auth_clean_arch/features/registration/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_bloc_test.mocks.dart';

@GenerateMocks([
  LoginUseCase,
  EmailValidator,
  PasswordValidator
])
main() {
  late MockEmailValidator mockEmailValidator;
  late MockPasswordValidator mockPasswordValidator;
  late MockLoginUseCase mockLoginUseCase;
  late SignInBloc bloc;
  //-------------
  String email = 'test@test.com';
  String password = '123qweAAA';
  String firstName = 'firstName';
  String lastName = 'lastName';
  DateTime createTime = DateTime.now();
  DateTime? lastLogin;
  bool emailVerified = false;
  User user = User(
      id: 1,
      email: email,
      firstName: firstName,
      lastName: lastName,
      createTime: createTime,
      lastLogin: lastLogin,
      emailVerified: emailVerified);
  SignInEvent event = SignInRequest(email: email, password: password);

  setUp(() {
    mockEmailValidator = MockEmailValidator();
    mockPasswordValidator = MockPasswordValidator();
    mockLoginUseCase = MockLoginUseCase();
    bloc = SignInBloc(
        emailValidator: mockEmailValidator,
        passwordValidator: mockPasswordValidator,
        loginUseCase: mockLoginUseCase);
  });
  var invalidInputFailure = const InvalidInputFailure([]);
  var loginFailure = const UserNotFoundFailure([]);
  /// put false for any one to invalidate
  void mock({bool validPassword = true, bool validEmail= true, bool validUsecase = true}) {
    when(mockPasswordValidator.validate(any))
        .thenAnswer((_) => validPassword ? Right(password): Left(invalidInputFailure));
    when(mockEmailValidator.validate(any)).thenAnswer((_) => validEmail ? Right(email) : Left(invalidInputFailure));
    when(mockLoginUseCase.call(any)).thenAnswer((_) async => validUsecase ? Right(user) : Left(loginFailure));
  }
  group('Good scenario', (){
    setUp((){
      mock();
    });
    blocTest<SignInBloc, SignInState>(
      'should return the user',
      build: () => bloc,
      act: (bloc) {
        bloc.add(event);
      },
      expect: () => <SignInState>[
        Loading(),
        Success(user)
      ],
    );
  });

  group('Bad Scenario', (){
    blocTest<SignInBloc, SignInState>(
      'should emit failure if the password is invalid',
      build: () => bloc,
      act: (bloc) {
        mock(validPassword: false);
        bloc.add(event);
      },
      expect: () => <SignInState>[
        ValidationError(invalidInputFailure)
      ],
    );

    blocTest<SignInBloc, SignInState>(
      'should emit failure if the email is invalid',
      build: () => bloc,
      act: (bloc) {
        mock(validEmail: false);
        bloc.add(event);
      },
      expect: () => <SignInState>[
        ValidationError(invalidInputFailure)
      ],
    );

    blocTest<SignInBloc, SignInState>(
      'should emit failure if the user can\'t be login',
      build: () => bloc,
      act: (bloc) {
        mock(validUsecase: false);
        bloc.add(event);
      },
      expect: () => <SignInState>[
        Loading(),
        LoginError(loginFailure)
      ],
    );
  });
}
