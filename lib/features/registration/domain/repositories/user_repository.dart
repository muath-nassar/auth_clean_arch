import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import 'package:dartz/dartz.dart';

import '../use_cases/sign_up_use_case.dart';

abstract class UserRepository{
  //GET methods
  Future<Either<Failure,User>> getUserByEmail(String email);
  Future<Either<Failure,User>> getUserById(int id);
  Future<Either<Failure,UserLoginCredentials>> getUserAuthCredentials(String email);
  //POST methods
  Future<Either<Failure,User>> createUser(UserCreateParams newUser);
  //UPDATE methods
  Future<Either<Failure,User>> updateUser(User updatedUser);
  /// 0 means no Current user. otherwise it is the current user id.
  /// For sign out please call with 0.
  Future<Either<Failure, int>> cacheCurrentUser(int id);
  // DELETE methods
  Future<Either<Failure,User>> deleteUser(int userId);
}