import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_model.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_user_datasource.dart';
import '../datasources/remote_user_datasource.dart';

class UserRepositoryImp extends UserRepository {
  LocalUserDatasource localUserDatasource;
  RemoteUserDataSource remoteUserDataSource;

  UserRepositoryImp(
      {required this.remoteUserDataSource, required this.localUserDatasource});

  @override
  Future<Result<bool>> changePassword(int userId, String newPassword) async{
    try{
      bool value = await remoteUserDataSource.changePassword(userId, newPassword);
      return Result.success(value);

    }on ServerException catch(_){
      return Result<bool>.failure(const ServerFailure(['Server Error']));
    }
  }

  @override
  Future<Result<User>> createUser(String email, String password, String firstName, String lastName) async {
    try {
      User user = await remoteUserDataSource.createUser(
          email, password, firstName, lastName);
      return Result<User>.success(user);
    } on UserCreateException catch (_) {
      return Result<User>.failure(
          const UserCreateFailure(['User can\'t be created']));
    } on NetworkException catch (_) {
      return Result<User>.failure(
          const NetworkFailure(['Internet connection is down']));
    }
  }

  @override
  Future<Result<User>> deleteUser(int userId) async{
    try{
      User deletedUser = await remoteUserDataSource.deleteUser(userId);
      return Result<User>.success(deletedUser);
    }on NetworkException catch (_) {
      return Result<User>.failure(
          const NetworkFailure(['Internet connection is down']));
    }on ServerException catch(_){
      return Result<User>.failure(ServerFailure(['can\'t delete the user $userId']));
    }
  }

  @override
  Future<Result<User>> getUser(int userId)async {
    try {
      User user = await remoteUserDataSource.getUser(userId);
      return Result.success(user);
    } on NetworkException catch (_) {
      return Result.failure(const NetworkFailure(['Internet connection is down']));
    }on FormatException catch(_){
      return Result<User>.failure(const FormatFailure(['Invalid user json']));
    }on ServerException catch (_) {
      return Result.failure(ServerFailure(['Unable to retrieve user with id: $userId']));
    }
  }

  @override
  Future<Result<User>> login(String email, String password) async {
    try{
      User user = await remoteUserDataSource.login(email, password);
      await localUserDatasource.cacheCurrentUser(user as UserModel);
      return Result<User>.success(user);
    } on NetworkException catch (_) {
      return Result<User>.failure(const NetworkFailure(['Internet connection is down']));
    } on LoginException catch(_){
      return Result<User>.failure(const WrongCredentialsFailure(['Invalid email or password']));
    }on FormatException catch(_){
      return Result<User>.failure(const FormatFailure(['Invalid user json']));
    }on ServerException catch(_){
      return Result<User>.failure(const ServerFailure(['Server error']));
    }
    }

  @override
  Future<Result<void>> logout() async{
    var delete = await localUserDatasource.deleteCurrentUser();
    return Result<void>.success(delete);
  }

  @override
  Future<Result<User>> updateUser(int userId, User updatedUser)async {
    try{
      User updated = await remoteUserDataSource.updateUser(userId, updatedUser);
      await localUserDatasource.cacheCurrentUser(updated as UserModel);
      return Result.success(updated);
    }on NetworkException catch (_) {
      return Result<User>.failure(const NetworkFailure(['Internet connection is down']));
    }on FormatException catch(_){
      return Result<User>.failure(const FormatFailure(['Invalid user json']));
    }on ServerException catch(_){
      return Result<User>.failure(const ServerFailure(['Server error']));
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async{
    User? user = await localUserDatasource.getLastCachedUser();
    if(user != null){
      return Result.success(user);
    }
    return Result<User>.failure(const NoCachedUserFailure([]));
  }

  @override
  Future<Result<User>> getUserByEmail(String email) async{
    try {
      User user = await remoteUserDataSource.getUserByEmail(email);
      return Result.success(user);
    } on NetworkException catch (_) {
      return Result.failure(const NetworkFailure(['Internet connection is down']));
    }on FormatException catch(_){
      return Result<User>.failure(const FormatFailure(['Invalid user json']));
    }on ServerException catch (_) {
      return Result.failure(ServerFailure(['Unable to retrieve user with email: $email']));
    }
  }
}
