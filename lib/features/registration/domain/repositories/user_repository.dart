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
  // DELETE methods
  Future<Either<Failure,User>> deleteUser(int userId);
}