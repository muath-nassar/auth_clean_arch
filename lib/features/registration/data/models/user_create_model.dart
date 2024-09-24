import 'package:auth_clean_arch/core/database/database.dart' as db;
import 'package:drift/drift.dart';

import '../../domain/use_cases/sign_up_use_case.dart';

class UserCreateModel extends UserCreateParams {
  const UserCreateModel({
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.password,
  });

  factory UserCreateModel.fromParams(UserCreateParams params){
    return UserCreateModel(email: params.email, firstName: params.firstName, lastName: params.lastName, password: params.password);
  }

  db.UsersCompanion toDB() {
    return db.UsersCompanion(
      email: Value(email),
      hashPassword: Value(password),
      firstName: Value(firstName),
      lastName: Value(lastName),
      createTime: Value(DateTime.now()),
      emailVerified: const Value(false),
      lastLogin: const Value(null),
    );
  }
}
