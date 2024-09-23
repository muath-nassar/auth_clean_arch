import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';

import '../../../../core/database/database.dart' as db;

class UserLoginCredentialsModel extends UserLoginCredentials{
  const UserLoginCredentialsModel({
    required super.email,
    required super.encryptedPassword,
  });

  factory UserLoginCredentialsModel.fromDB(db.User user){
    return UserLoginCredentialsModel(
        email: user.email,
        encryptedPassword: user.hashPassword,
    );
  }

}