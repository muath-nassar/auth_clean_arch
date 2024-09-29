

import '../models/user_model.dart';

abstract class LocalUserDatasource{
  Future<void> cache(UserModel userModel);

  Future<UserModel> getLastCachedUser();

  Future<void> removeLastCachedUser();
}

class LocalUserDatasourceImpl extends LocalUserDatasource{
  @override
  Future<void> cache(UserModel userModel) {
    // TODO: implement cache
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getLastCachedUser() {
    // TODO: implement getLastCachedUser
    throw UnimplementedError();
  }

  @override
  Future<void> removeLastCachedUser() {
    // TODO: implement removeLastCachedUser
    throw UnimplementedError();
  }



}