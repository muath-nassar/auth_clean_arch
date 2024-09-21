import 'package:equatable/equatable.dart';

import '../../../../core/entities/base_user.dart';

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


