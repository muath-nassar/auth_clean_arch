

import 'package:hive/hive.dart';

import '../models/user_model.dart';

abstract class LocalUserDatasource{
  Future<void> cacheCurrentUser(UserModel userModel);

  Future<UserModel?> getLastCachedUser();

  Future<void> deleteCurrentUser();
}

String currentUserKey = 'currentUser';
class LocalUserDatasourceImpl extends LocalUserDatasource{
  final Box<UserModel> userBox;

  LocalUserDatasourceImpl(this.userBox);

  @override
  Future<void> cacheCurrentUser(UserModel user) async {
    await userBox.put(currentUserKey, user);
  }

  @override
  Future<UserModel?> getLastCachedUser() async {
    return userBox.get(currentUserKey);
  }

  @override
  Future<void> deleteCurrentUser() async {
    await userBox.delete(currentUserKey);
  }

}