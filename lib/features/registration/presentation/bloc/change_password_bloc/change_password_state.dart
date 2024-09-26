part of 'change_password_bloc.dart';

sealed class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

final class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

final class InvalidEmailState extends ChangePasswordState{
  final Failure failure;

  const InvalidEmailState(this.failure);

  @override
  List<Object?> get props => [failure];
}
final class SendingState extends ChangePasswordState{
  @override
  List<Object?> get props => [];
}
final class SendErrorState extends ChangePasswordState{
  final Failure failure;

  const SendErrorState(this.failure);

  @override
  List<Object?> get props => [failure];
}

final class SendSuccessState extends ChangePasswordState{
  @override
  List<Object?> get props => [];
}

final class InvalidPasswordState extends ChangePasswordState{
  final Failure failure;

  const InvalidPasswordState(this.failure);
  @override
  List<Object?> get props => [failure];
}

final class ChangePasswordErrorState extends ChangePasswordState{
  final Failure failure;

  const ChangePasswordErrorState(this.failure);
  @override
  List<Object?> get props => [failure];
}

final class ChangePasswordSuccessState extends ChangePasswordState{
  final String newHashedPassword;

  const ChangePasswordSuccessState(this.newHashedPassword);
  @override
  List<Object?> get props => [newHashedPassword];
}


