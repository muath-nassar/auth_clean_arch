import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/validators/email_validator.dart';
import '../../../domain/use_cases/verify_email_use_case.dart';

part 'verify_email_event.dart';

part 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  final EmailValidator emailValidator;
  final VerifyEmailUseCase verifyEmailUseCase;

  VerifyEmailBloc(
      {required this.emailValidator, required this.verifyEmailUseCase})
      : super(VerifyEmailInitial()) {
    on<VerifyEmailEvent>((event, emit) {
      if(event is SendEmailEvent){
       _onSendEvent(event,emit);
      }
      if(event is VerifyCodeEvent){
        _onVerifyCodeEvent(event, emit);
      }
    });
  }

  void _onSendEvent(SendEmailEvent event, emit)async{
    // Step 1 start validate email
    late String email;
    var validationEmail = emailValidator.validate(event.email);
    validationEmail.fold(
            (emailValidationFailure){
          emit(InvalidEmail(emailValidationFailure));
        },
            (value){
          email = value;
        });
    if(validationEmail.isLeft()) return;
    // Step 2 start check email sending
    emit(Sending());
    var sendEmailCall = await verifyEmailUseCase
        .sendEmail(EmailParams(email: email));
    sendEmailCall.fold(
            (sendFailure){
          emit(SendError(sendFailure));
        },
            (sentCode){
          emit(SendSuccess());
        });
  }

  Future<void> _onVerifyCodeEvent(VerifyCodeEvent event, Emitter<VerifyEmailState> emit) async {
    (await verifyEmailUseCase.verifyEmail(event.inputCode)).fold(
            (failure){
              emit(UnverifiedEmail(failure));
            },
            (user){
              emit(VerifiedEmail());
            });
  }
}
