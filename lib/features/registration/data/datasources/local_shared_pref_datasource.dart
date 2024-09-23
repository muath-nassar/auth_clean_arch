import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalSharedPrefDatasource{
  /// Throws [CacheException] if can't save the current user.
  Future<void> cache(int id);

  /// Gets the cached [int] which was logged in through the last time
  ///
  /// Throws [CacheException] if no cached data is present.
  int getCurrentUserId();
}

class LocalSharedPrefDatasourceImpl extends LocalSharedPrefDatasource{
  String key = 'CURRENT_USER_ID';
  SharedPreferences pref;
  LocalSharedPrefDatasourceImpl(this.pref);

  @override
  Future<void> cache(int id) async{
    var result = await pref.setInt('CURRENT_USER_ID', id);
    if (result == false) throw CacheException();
  }

  @override
  int getCurrentUserId(){
    var currentId = pref.getInt(key);
    if (currentId == null) throw CacheException();
    return currentId;
  }

}