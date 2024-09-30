

import '../../../../core/result/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_user_datasource.dart';
import '../datasources/remote_user_datasource.dart';

class UserRepositoryImp extends UserRepository {
  LocalUserDatasource localUserDatasource;
  RemoteUserDataSource remoteUserDataSource;

  UserRepositoryImp({required this.remoteUserDataSource, required this.localUserDatasource});
  @override
  Future<Result<bool>> changePassword(int userId, String newPassword) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> createUser(String email, String password, String firstName, String lastName) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> deleteUser(int userId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> getUser(int userId) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> updateUser(int userId, User updatedUser) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

}


  //------------------------- Error Messages---------------------
  String errorMsgNoId(int id) => 'No user found with id $id';

  String errorMsgNoEmail(String email) => 'No user found for $email';

  String errorMsgDelete(int id) => "Can't delete the user with id $id";

  String errorMsgUpdate(int id) => "Can't update the user with id $id";

  String errorMsgPasswordChange(int id) =>
      "Can't change password for the user with id $id";

