import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/validators/password_validator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/validators/email_validator.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/login_use_case.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final EmailValidator emailValidator;
  final PasswordValidator passwordValidator;
  final LoginUseCase loginUseCase;
  SignInBloc({
    required this.emailValidator,
    required this.passwordValidator,
    required this.loginUseCase,
}) : super(SignInInitial()) {
    on<SignInEvent>((event, emit) async {
      if(event is SignInRequest){
        late String email,password;
        // Validation
        var emailValidation = emailValidator.validate(event.email);
        emailValidation.fold(
                (failure){emit(ValidationError(failure));},
                (value){email = value;});
        if (emailValidation.isLeft()) return;
        var passwordValidation = passwordValidator.validate(event.password);
        passwordValidation.fold(
                (failure){emit(ValidationError(failure));},
                (value){password = value;});
        if (passwordValidation.isLeft()) return;
        LoginParams params = LoginParams(
          email: email,
          password: password,
        );

        emit(Loading());
        var userLogin = await loginUseCase(params);
        userLogin.fold(
                (failure){
              emit(LoginError(failure));
            },
                (user){
              emit(Success(user));
            });
      }
    });
  }
}
