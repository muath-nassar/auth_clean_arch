part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();
}

final class SendEmail extends ChangePasswordEvent{
  final String email;

  const SendEmail(this.email);

  @override
  List<Object?> get props => [email];
}

final class ChangePasswordRequest extends ChangePasswordEvent{
  final String newPassword;
  final String code;

  const ChangePasswordRequest(this.newPassword, this.code);

  @override
  List<Object?> get props => [newPassword, code];
}


