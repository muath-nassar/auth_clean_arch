part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();
}

final class SignInInitial extends SignInState {
  @override
  List<Object> get props => [];
}

// Errors
class ValidationError extends SignInState{
  final Failure failure;
  const ValidationError(this.failure);
  @override
  List<Object?> get props => [failure];
}

class Loading extends SignInState{
  @override
  List<Object?> get props => [];
}

class Success extends SignInState{
  final User user;
  const Success(this.user);
  @override
  List<Object?> get props => [user];
}

class LoginError extends SignInState{
  final Failure failure;
  const LoginError(this.failure);
  @override
  List<Object?> get props => [failure];
}


