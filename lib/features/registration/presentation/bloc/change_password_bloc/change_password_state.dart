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

final class SearchEmailStat extends ChangePasswordState{
  @override
  List<Object?> get props =>  [];
}

final class UserFoundState extends ChangePasswordState{
  final int id;

  const UserFoundState(this.id);
  @override
  List<Object?> get props =>  [id];
}

final class UserNotFoundState extends ChangePasswordState{
  @override
  List<Object?> get props =>  [];
}




final class InvalidPasswordState extends ChangePasswordState{
  final Failure failure;

  const InvalidPasswordState(this.failure);
  @override
  List<Object?> get props => [failure];
}


final class ChangingPasswordState extends ChangePasswordState{
  @override
  List<Object?> get props => [];
}


final class ChangePasswordErrorState extends ChangePasswordState{
  final Failure failure;

  const ChangePasswordErrorState(this.failure);
  @override
  List<Object?> get props => [failure];
}

final class ChangePasswordSuccessState extends ChangePasswordState{

  @override
  List<Object?> get props => [];
}


