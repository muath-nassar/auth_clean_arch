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
        await _handleSignIn(event,emit);
      }
    });
  }

  _handleSignIn(SignInRequest event, Emitter<SignInState> emit) async {
    // email validation
    var emailValidation = emailValidator.validate(event.email);
    if (!emailValidation.isSuccess()) {
      emit(ValidationError(emailValidation.failure!));
      return;
    }

    // password validation
    var passwordValidation = passwordValidator.validate(event.password);
    if (!passwordValidation.isSuccess()) {
      emit(ValidationError(passwordValidation.failure!));
      return;
    }

    emit(Loading());

    // Attempting Sign in

    var action = await loginUseCase(LoginParams(email: event.email, password: event.password));

    if(action.isSuccess()){
      emit(Success(action.data!));
    }else {
      emit(LoginError(action.failure!));
    }
  }
}
