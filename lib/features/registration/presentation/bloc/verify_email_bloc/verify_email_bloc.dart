import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/validators/email_validator.dart';

part 'verify_email_event.dart';

part 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  final EmailValidator emailValidator;
  // final VerifyEmailUseCase verifyEmailUseCase;

  VerifyEmailBloc(
      {required this.emailValidator})
      : super(VerifyEmailInitial()) {
    on<VerifyEmailEvent>((event, emit) async{


    });
  }


}
