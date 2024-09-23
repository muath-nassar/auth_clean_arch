import 'package:auth_clean_arch/core/database/database.dart';
import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_create_model.dart';

import '../models/user_model.dart';

abstract class UserModelLocalDbDatasource{
  Future<bool> createUser(UserCreateModel user);

  /// throws [UserNotFoundException]
  Future<UserModel> getUserById(int id);

  /// throws [UserNotFoundException]
  Future<UserModel> getUserByEmail(String email);

  Future<bool> setEmailVerification(int id, bool verified);

  Future<bool> updateLastLogin(int id, DateTime dateTime);

  Future<bool> changePassword(int id, String password);

  Future<bool> updateUser(UserModel userModel);

  Future<bool> deleteUser(int id);
}

class UserModelLocalDbDatasourceImpl extends UserModelLocalDbDatasource{
  final AppDatabase db;

  UserModelLocalDbDatasourceImpl({required this.db});


  @override
  Future<bool> createUser(UserCreateModel user) async{
      var affectedRows = await db.insertUser(user.toDB());
      return affectedRows > 0;
  }

  @override
  Future<bool> changePassword(int id, String password) async {
    return await db.changePassword(id, password) > 0;
  }

  @override
  Future<bool> deleteUser(int id) async{
    return await db.deleteUser(id) > 0;
  }

  @override
  Future<UserModel> getUserByEmail(String email)async {
      var userDb = await db.getUserByEmail(email);
      if(userDb == null) throw UserNotFoundException();
      return UserModel.fromDB(userDb);
  }

  @override
  Future<UserModel> getUserById(int id)async {
    var userDb = await db.getUser(id);
    if(userDb == null) throw UserNotFoundException();
    return UserModel.fromDB(userDb);
  }

  @override
  Future<bool> setEmailVerification(int id, bool verified)async {
    return await db.setEmailVerified(id, verified) > 0;
  }

  @override
  Future<bool> updateLastLogin(int id, DateTime dateTime) async{
    return await db.updateLastLogin(id, dateTime) > 0;
  }

  @override
  Future<bool> updateUser(UserModel userModel) async{
    return await db.updateUser(userModel.toDB());
  }


}
