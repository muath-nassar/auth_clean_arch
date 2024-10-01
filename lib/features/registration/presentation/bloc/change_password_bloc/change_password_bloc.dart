import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/validators/email_validator.dart';
import '../../../../../core/utils/validators/password_validator.dart';
import '../../../domain/use_cases/forget_password_use_case.dart';
import '../../../domain/use_cases/get_user_using_email_usecase.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final EmailValidator emailValidator;
  final PasswordValidator passwordValidator;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final GetUserUsingEmailUsecase getUserUsingEmailUsecase;

  int? userId;
  ChangePasswordBloc({
    required this.emailValidator,
    required this.passwordValidator,
    required this.forgetPasswordUseCase,
    required this.getUserUsingEmailUsecase
}) : super(ChangePasswordInitial()) {
    on<ChangePasswordEvent>((event, emit) async {
      if(event is SearchEmailRequest){
        await _onSearchEmail(event,emit);
      }
      if(event is ChangePasswordRequest){
        await _onChangePassword(event,emit);
      }
    });


  }

  Future<void> _onSearchEmail(SearchEmailRequest event, Emitter<ChangePasswordState> emit) async {
    // email validation
    var emailValidation = emailValidator.validate(event.email);
    if (!emailValidation.isSuccess()) {
      emit(InvalidEmailState(emailValidation.failure!));
      return;
    }

    //Searching
    emit(SearchEmailState());
    var action = await getUserUsingEmailUsecase(EmailParams(event.email));
    if(action.isSuccess()){
      userId = action.data!.id;
      emit(UserFoundState(userId!));
    }else{
      emit(UserNotFoundState(UserNotFoundFailure(['no account for ${event.email}'])));
    }

  }

  Future<void> _onChangePassword(ChangePasswordRequest event, Emitter<ChangePasswordState> emit) async {
    if(userId == null){
      emit(const UserNotFoundState(UserNotFoundFailure(['Please add a valid email!'])));
      return;
    }
    // email validation
    var passwordValidation = passwordValidator.validate(event.newPassword);
    if (!passwordValidation.isSuccess()) {
      emit(InvalidPasswordState(passwordValidation.failure!));
      return;
    }

    // attempting to change the password
    emit(ChangingPasswordState());
    var changePasswordAction = await forgetPasswordUseCase(
        ForgetPasswordParams(id: userId!, password: event.newPassword));
    if(changePasswordAction.isSuccess()){
      emit(ChangePasswordSuccessState());
    }else{
      emit(ChangePasswordErrorState(changePasswordAction.failure!));
    }


  }


}
