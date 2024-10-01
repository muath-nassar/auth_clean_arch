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
      if (event is SignUpRequest) {
        await _handleSignUpRequest(event, emit);
      }
    });
  }

  Future<void> _handleSignUpRequest(SignUpRequest event, Emitter<SignUpState> emit) async {
    // Validate email
    var emailValidation = emailValidator.validate(event.email);
    if (!emailValidation.isSuccess()) {
      emit(Error(emailValidation.failure!));
      return;
    }

    // Validate password
    var passwordValidation = passwordValidator.validate(event.password);
    if (!passwordValidation.isSuccess()) {
      emit(Error(passwordValidation.failure!));
      return;
    }

    emit(Loading());

    // Attempt sign up
    var action = await signUpUserCase(UserCreateParams(
      email: event.email,
      firstName: event.firstName,
      lastName: event.lastName,
      password: event.password,
    ));

    if (action.isSuccess()) {
      emit(Success(action.data!));
    } else {
      emit(Error(action.failure!));
    }
  }
}
