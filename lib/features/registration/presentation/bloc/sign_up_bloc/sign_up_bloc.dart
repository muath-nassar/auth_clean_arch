import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/validators/email_validator.dart';
import '../../../../../core/utils/validators/password_validator.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/sign_up_use_case.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  EmailValidator emailValidator;
  PasswordValidator passwordValidator;
  SignUpUseCase signUpUserCase;


  SignUpBloc({
    required this.emailValidator,
    required this.passwordValidator,
    required this.signUpUserCase,
  }) : super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) async {
      if(event is SignUpRequest){
        late String email, firstName, lastName, password;
        // Validation
        var emailValidation = emailValidator.validate(event.email);
        emailValidation.fold(
                (failure){emit(Error(failure));},
                (value){email = value;});
        if (emailValidation.isLeft()) return;
        var passwordValidation = passwordValidator.validate(event.password);
        passwordValidation.fold(
                (failure){emit(Error(failure));},
                (value){password = value;});
        if (passwordValidation.isLeft()) return;
        firstName = event.firstName;
        lastName = event.lastName;
        UserCreateParams params = UserCreateParams(
            email: email,
            firstName: firstName,
            lastName: lastName,
            password: password,
        );

        emit(Loading());
        var userCreation = await signUpUserCase(params);
        userCreation.fold(
                (failure){
                  emit(Error(failure));
                },
                (newUser){
                  emit(Success(newUser));
                });
      }
    });
  }
}
