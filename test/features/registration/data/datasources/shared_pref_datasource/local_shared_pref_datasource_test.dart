
import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/local_shared_pref_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_shared_pref_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
main(){
  late MockSharedPreferences mockSharedPreferences;
  late LocalSharedPrefDatasourceImpl datasource;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    datasource = LocalSharedPrefDatasourceImpl(mockSharedPreferences);
  });

  group('catch', (){
    test('green scenario ', () async {
      // Arrange
      when(mockSharedPreferences.setInt(any, any)).thenAnswer((_)async=>true);
      // Act
      await datasource.cache(1);
      // Assert
      verify(mockSharedPreferences.setInt(datasource.key,1));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
    test('red scenario ', () async {
      // Arrange
      when(mockSharedPreferences.setInt(any, any)).thenAnswer((_)async=>false);
      // Act
     var call =  datasource.cache;
      // Assert
      expect(()=>call(1), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('getCurrentUserID', (){
    test('green scenario ', () {
      // Arrange
      when(mockSharedPreferences.getInt(any)).thenAnswer((_)=>1);
      // Act
      var result = datasource.getCurrentUserId();
      // Assert
      expect(result, 1);
      verify(mockSharedPreferences.getInt(datasource.key));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
    test('red scenario ', () async {
      // Arrange
      when(mockSharedPreferences.getInt(any)).thenAnswer((_)=>null);
      // Act
      var call =  datasource.getCurrentUserId;
      // Assert
      expect(()=>call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
