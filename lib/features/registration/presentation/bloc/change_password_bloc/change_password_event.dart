part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();
}

final class ChangePasswordRequest extends ChangePasswordEvent{
  final String newPassword;
  final String id;

  const ChangePasswordRequest(this.id, this.newPassword);

  @override
  List<Object?> get props => [newPassword, id];
}

final class SearchEmailRequest extends ChangePasswordEvent{
  final String email;

  const SearchEmailRequest(this.email);

  @override
  List<Object?> get props => [email];

}


