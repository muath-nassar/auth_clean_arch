import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/core/utils/validators/password_validator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/validators/email_validator.dart';
import '../../../domain/use_cases/forget_password_use_case.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final EmailValidator emailValidator;
  final PasswordValidator passwordValidator;
  final ForgetPasswordUseCase useCase;
  ChangePasswordBloc({
    required this.emailValidator,
    required this.passwordValidator,
    required this.useCase,
}) : super(ChangePasswordInitial()) {
    on<ChangePasswordEvent>((event, emit) async {
      if(event is SendEmail){
       await _onSendEmailEvent(event,emit);
      }
      if(event is ChangePasswordRequest){
        await _onVerifyCodeEvent(event,emit);
      }
    });
  }

  Future<void> _onSendEmailEvent(SendEmail event, Emitter<ChangePasswordState> emit) async {
    late String email;
    // email validation
    var emailValidation = emailValidator.validate(event.email);
    emailValidation.fold(
            (emailValidationFailure){
              emit(InvalidEmailState(emailValidationFailure));
            },
            (verifiedEmail){
              email = verifiedEmail;
              emit(SendingState());
            });
    if(emailValidation.isLeft()){
      return;
    }
    // Sending
    emit(SendingState());
    var send = await useCase.sendEmail(EmailParams(email: email));
    send.fold((failure){
      emit(SendErrorState(failure));
    }, (code){
      emit(SendSuccessState());
    });
  }

  Future<void> _onVerifyCodeEvent(ChangePasswordRequest event, Emitter<ChangePasswordState> emit)async {
    late String newPassword;
    var passwordValidation = passwordValidator.validate(event.newPassword);
    passwordValidation.fold(
            (failure){
              emit(InvalidPasswordState(failure));
            },
            (newPass){
              newPassword = newPass;
            });
    if(passwordValidation.isLeft()) return;
    // Changing Now
    var change = await useCase.updatePassword(event.code, newPassword);
    change.fold((failure){
      emit(ChangePasswordErrorState(failure));
    }, (changedPass){
      emit(ChangePasswordSuccessState(changedPass));
    });
  }
}
