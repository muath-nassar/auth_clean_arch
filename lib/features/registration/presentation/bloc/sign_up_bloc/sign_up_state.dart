part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  @override
  List<Object> get props => [];
}

final class Loading extends SignUpState {
  @override
  List<Object> get props => [];
}

final class Error extends SignUpState {
  final Failure failure;
  const Error(this.failure);
  @override
  List<Object> get props => [failure];
}

final class Success extends SignUpState {
  final User user;

  const Success(this.user);
  @override
  List<Object> get props => [];
}


