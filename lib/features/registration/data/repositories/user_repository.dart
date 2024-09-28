import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/local_db_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/local_shared_pref_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_create_model.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_model.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/sign_up_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class UserRepositoryImp extends UserRepository {
  LocalSharedPrefDatasource prefDatasource;
  UserModelLocalDbDatasource dbDatasource;

  UserRepositoryImp({
    required this.dbDatasource,
    required this.prefDatasource,
  });

  @override
  Future<Either<Failure, User>> createUser(UserCreateParams newUser) async {
    bool query;
    try{query = await dbDatasource.createUser(UserCreateModel.fromParams(newUser));}
     on InvalidDataException catch(e){
      print(e);
      return const Left(UserCreateFailure(["User can't be created. The email may be taken!"]));
     }

    if (query) {
      try {
        return Right(await dbDatasource.getUserByEmail(newUser.email));
      } on UserNotFoundException catch (_) {
        debugPrint("Can't get the user after creation");
        return const Left(
            UserCreateFailure(["Can't get the user after creation"]));
      }
    }
    return const Left(UserCreateFailure(["User can't be created"]));
  }

  @override
  Future<Either<Failure, User>> getUserByEmail(String email) async {
    try {
      return Right(await dbDatasource.getUserByEmail(email));
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure([errorMsgNoEmail(email)]));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(int id) async {
    try {
      return Right(await dbDatasource.getUserById(id));
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure([errorMsgNoId(id)]));
    }
  }

  @override
  Future<Either<Failure, User>> deleteUser(int userId) async {
    try {
      var user = await dbDatasource.getUserById(userId);
      var delete = await dbDatasource.deleteUser(userId);
      if (delete) return Right(user);
      return Left(DatabaseWriteFailure([errorMsgDelete(userId)]));
    } on UserNotFoundException catch (_) {
      return Left(UserNotFoundFailure([errorMsgNoId(userId)]));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User updatedUser) async {
    try {
      UserModel u = UserModel.fromUser(updatedUser);
      var update = await dbDatasource.updateUser(u);
      if (update) {
        var afterUpdate = await dbDatasource.getUserById(updatedUser.id);
        return Right(afterUpdate);
      }
      return Left(DatabaseWriteFailure([errorMsgUpdate(updatedUser.id)]));
    } on UserNotFoundException catch (_) {
      return Left(UserNotFoundFailure([errorMsgNoId(updatedUser.id)]));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword(
      String email, String newPassword) async {
    UserModel user;
    try {
      user = await dbDatasource.getUserByEmail(email);
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure([errorMsgNoEmail(email)]));
    }
    if (await dbDatasource.changePassword(user.id, newPassword)) {
      return Right(newPassword);
    }
    return Left(DatabaseWriteFailure([errorMsgPasswordChange(user.id)]));
  }

  @override
  Future<Either<Failure, UserLoginCredentials>> getUserAuthCredentials(
      String email) async {
    try {
      var userAuthModel = await dbDatasource.getLoginCredentials(email);
      return Right(userAuthModel);
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure([errorMsgNoEmail(email)]));
    }
  }

  @override
  Future<Either<Failure, int>> cacheCurrentUser(int id) async {
    try {
      await prefDatasource.cache(id);
      return Right(id);
    } on CacheException catch (_) {
      return const Left(CacheFailure([]));
    }
  }

  @override
  Future<Either<Failure, int>> getCurrentUserId() async {
    try {
      var id = prefDatasource.getCurrentUserId();
      return Right(id);
    } on CacheException catch (_) {
      return const Left(CacheFailure([]));
    }
  }

  //------------------------- Error Messages---------------------
  String errorMsgNoId(int id) => 'No user found with id $id';

  String errorMsgNoEmail(String email) => 'No user found for $email';

  String errorMsgDelete(int id) => "Can't delete the user with id $id";

  String errorMsgUpdate(int id) => "Can't update the user with id $id";

  String errorMsgPasswordChange(int id) =>
      "Can't change password for the user with id $id";
}
