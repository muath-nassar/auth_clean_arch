part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpRequest extends SignUpEvent{
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const SignUpRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName];

}
