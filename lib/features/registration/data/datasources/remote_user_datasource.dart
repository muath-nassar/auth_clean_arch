import '../../../../core/result/result.dart';
import '../../domain/entities/user.dart';

abstract class RemoteUserDataSource{
  Future<Result<User>> getUser(int userId);

  Future<Result<User>> login(String email, String password);

  Future<Result<User>> updateUser(int userId, User updatedUser);

  Future<Result<bool>> changePassword(int userId, String newPassword);

  Future<Result<User>> createUser(
      String email, String password, String firstName, String lastName);

  Future<Result<User>> deleteUser(int id);
}

