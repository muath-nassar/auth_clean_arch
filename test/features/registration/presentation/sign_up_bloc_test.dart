import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/validators/email_validator.dart';
import 'package:auth_clean_arch/core/utils/validators/password_validator.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/sign_up_use_case.dart';
import 'package:auth_clean_arch/features/registration/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'sign_up_bloc_test.mocks.dart';

@GenerateMocks([
  SignUpUseCase,
  EmailValidator,
  PasswordValidator,
])
main() {
  late MockEmailValidator mockEmailValidator;
  late MockPasswordValidator mockPasswordValidator;
  late MockSignUpUseCase mockSignUpUseCase;
  late SignUpBloc bloc;
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
  SignUpEvent event = RequestSignUpEvent(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName);
  setUp(() {
    mockEmailValidator = MockEmailValidator();
    mockPasswordValidator = MockPasswordValidator();
    mockSignUpUseCase = MockSignUpUseCase();
    bloc = SignUpBloc(
        emailValidator: mockEmailValidator,
        passwordValidator: mockPasswordValidator,
        signUpUserCase: mockSignUpUseCase);
  });

  group('Good Scenario', () {

    void mockGood() {
      when(mockPasswordValidator.validate(any))
          .thenAnswer((_) => Right(password));
      when(mockEmailValidator.validate(any)).thenAnswer((_) => Right(email));
      when(mockSignUpUseCase.call(any)).thenAnswer((_) async => Right(user));
    }

    blocTest<SignUpBloc, SignUpState>(
      'should firstly show the initial state means []',
      build: () => bloc,
      act: (bloc) {
        mockGood();
      },
      expect: () => <SignUpState>[],
    );

    blocTest<SignUpBloc, SignUpState>(
      'should return the user',
      build: () => bloc,
      act: (bloc) {
        mockGood();
        bloc.add(event);
      },
      expect: () => <SignUpState>[
        Loading(),
        Success(user)
      ],
    );
  });

  group('Bad Scenarios', (){
    var invalidInputFailure = const InvalidInputFailure([]);
    var createFailure = const DatabaseWriteFailure([]);
    /// put false for any one to invalidate
    void mockBad({bool validPassword = true, bool validEmail= true, bool correctCreation = true}) {
      when(mockPasswordValidator.validate(any))
          .thenAnswer((_) => validPassword ? Right(password): Left(invalidInputFailure));
      when(mockEmailValidator.validate(any)).thenAnswer((_) => validEmail ? Right(email) : Left(invalidInputFailure));
      when(mockSignUpUseCase.call(any)).thenAnswer((_) async => correctCreation ? Right(user) : Left(createFailure));
    }

    blocTest<SignUpBloc, SignUpState>(
      'should emit failure if the password is invalid',
      build: () => bloc,
      act: (bloc) {
        mockBad(validPassword: false);
        bloc.add(event);
      },
      expect: () => <SignUpState>[
        Error(invalidInputFailure)
      ],
    );
    blocTest<SignUpBloc, SignUpState>(
      'should emit failure if the email is invalid',
      build: () => bloc,
      act: (bloc) {
        mockBad(validEmail: false);
        bloc.add(event);
      },
      expect: () => <SignUpState>[
        Error(invalidInputFailure)
      ],
    );
    blocTest<SignUpBloc, SignUpState>(
      'should emit failure if the user can\'t be created',
      build: () => bloc,
      act: (bloc) {
        mockBad(correctCreation: false);
        bloc.add(event);
      },
      expect: () => <SignUpState>[
        Loading(),
        Error(createFailure)
      ],
    );
  });
}
