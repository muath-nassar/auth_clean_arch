import 'package:auth_clean_arch/core/result/result.dart';

import '../entities/user.dart';


abstract class UserRepository {
  //GET methods
  Future<Result<User>> getUser(int userId);
  Future<Result<User>> getCurrentUser();

  // POST methods
  Future<Result<User>> createUser(
      String email, String password, String firstName, String lastName);

  Future<Result<User>> login(String email, String password);

  Future<Result<void>> logout();

  // UPDATE methods
  Future<Result<bool>> changePassword(int userId, String newPassword);

  Future<Result<User>> updateUser(int userId, User updatedUser);

  // Delete methods
  Future<Result<User>> deleteUser(int userId);
}
