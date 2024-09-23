import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:drift/drift.dart';

import '../../../../core/database/database.dart' as db;

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.createTime,
    required super.lastLogin,
    required super.emailVerified,
  });

  factory UserModel.fromDB(db.User dbUser) {
    return UserModel(
      id: dbUser.id,
      email: dbUser.email,
      firstName: dbUser.firstName,
      lastName: dbUser.lastName,
      createTime: dbUser.createTime,
      lastLogin: dbUser.lastLogin,
      emailVerified: dbUser.emailVerified,
    );
  }
  /// Hash password shouldn't be included. because changing the password need
  /// logic
  db.UsersCompanion toDB(){
    return db.UsersCompanion(
      email: Value<String>(email),
      firstName: Value<String>(firstName),
      lastName: Value<String>(lastName),
      createTime: Value<DateTime>(createTime),
      lastLogin: Value<DateTime?>(lastLogin),
      emailVerified: Value<bool>(emailVerified),
    );
  }
}
