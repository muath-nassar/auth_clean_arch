part of 'verify_email_bloc.dart';

sealed class VerifyEmailEvent extends Equatable {
  const VerifyEmailEvent();
}

final class SendEmailEvent extends VerifyEmailEvent{
  final String email;

  const SendEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

final class VerifyCodeEvent extends VerifyEmailEvent{
  final String inputCode;

  const VerifyCodeEvent(this.inputCode);

  @override
  List<Object?> get props => [inputCode];

}