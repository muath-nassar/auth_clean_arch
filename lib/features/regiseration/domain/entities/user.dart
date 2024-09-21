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

/// User Entity is the entity that you can get from the database with all fields
/// including the encrypted password. Also, it is the user entity that you can
/// post to the database.
class User extends BaseUser{
  final DateTime createTime;
  final DateTime? lastLogin;
  final bool emailVerified;

  const User({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required this.createTime,
    required this.lastLogin,
    required this.emailVerified,
});

  @override
  List<Object?> get props =>
      super.props + [createTime, lastLogin, emailVerified];

}

/// UserCreateDTO class is used to get the data needed to create a new user.
class UserCreateDTO extends BaseUser{
  final String password;

  const UserCreateDTO({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required this.password,
  });
  @override
  List<Object?> get props => super.props + [password];
}

/// This class is related to the data will be taken from the database for
/// the provided email and password.
class UserLoginCredentials extends Equatable{
  final String email;
  final String encryptedPassword;

  const UserLoginCredentials({
    required this.email,
    required this.encryptedPassword
  });

  @override
  List<Object?> get props => [email, encryptedPassword];
}


