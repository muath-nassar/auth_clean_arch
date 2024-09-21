import 'package:equatable/equatable.dart';

class BaseUser extends Equatable{
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  const BaseUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,

  });

  @override
  List<Object?> get props => [id, email, firstName, lastName];
}