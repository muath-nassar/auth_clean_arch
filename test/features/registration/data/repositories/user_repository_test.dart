import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/local_db_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/local_shared_pref_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_create_model.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_login_credentials_model.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_model.dart';
import 'package:auth_clean_arch/features/registration/data/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/sign_up_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([LocalSharedPrefDatasource, UserModelLocalDbDatasource])

main(){
  late MockLocalSharedPrefDatasource mockPrefDatasource;
  late MockUserModelLocalDbDatasource mockDbDatasource;
  late UserRepositoryImp repository;
  DateTime createTime = DateTime.now().subtract(const Duration(days: 1));
  DateTime lastLogin = DateTime.now();
  late UserModel userModel;

  setUp((){
    mockPrefDatasource = MockLocalSharedPrefDatasource();
    mockDbDatasource = MockUserModelLocalDbDatasource();
    repository = UserRepositoryImp(
        dbDatasource: mockDbDatasource,
        prefDatasource: mockPrefDatasource);
    userModel = UserModel(
        id: 1,
        email: 'teat@test.com',
        firstName: 'firstName',
        lastName: 'lastName',
        createTime: createTime,
        lastLogin: lastLogin,
        emailVerified: false);
  });


  group('Create User',(){
    late UserCreateParams newUserParams;
    late UserCreateModel userCreateModel;
    setUp((){
      newUserParams = const UserCreateParams(
          email: 'teat@test.com',
          firstName: 'firstName',
          lastName: 'lastName',
          password: 'password');

      userCreateModel = UserCreateModel.fromParams(newUserParams);
    });

    void mockGoodCreate(){
      when(mockDbDatasource.createUser(any)).thenAnswer((_)async=>true);
      when(mockDbDatasource.getUserByEmail(any)).thenAnswer((_)async=>userModel);
    }

    void mockNotSaved(){
      when(mockDbDatasource.createUser(any)).thenAnswer((_)async=>false);
      when(mockDbDatasource.getUserByEmail(any)).thenAnswer((_)async=>userModel);
    }

    void mockCanNotGetUser(){
      when(mockDbDatasource.createUser(any)).thenAnswer((_)async=>true);
      when(mockDbDatasource.getUserByEmail(any)).thenThrow(UserNotFoundException());
    }
    test('should call dbDatasource and not the shared', () async {
      // Arrange
      mockGoodCreate();
      // Act
      await repository.createUser(newUserParams);
      // Assert
      var model = UserCreateModel.fromParams(newUserParams);
      verify(mockDbDatasource.createUser(model));
      verifyZeroInteractions(mockPrefDatasource);
    });

    test('should get the user that has been created from the database', () async {
      // Arrange
      mockGoodCreate();
      // Act
      await repository.createUser(newUserParams);
      // Assert
      var model = UserCreateModel.fromParams(newUserParams);
      verify(mockDbDatasource.createUser(model));
      verify(mockDbDatasource.getUserByEmail(model.email));
      verifyZeroInteractions(mockPrefDatasource);
      verifyNoMoreInteractions(mockDbDatasource);
    });

    test('should return the saved user', () async {
      // Arrange
      mockGoodCreate();
      // Act
      var result = await repository.createUser(newUserParams);
      // Assert
      expect(result, Right(userModel));
      verify(mockDbDatasource.createUser(userCreateModel));
      verify(mockDbDatasource.getUserByEmail(userCreateModel.email));
      verifyZeroInteractions(mockPrefDatasource);
      verifyNoMoreInteractions(mockDbDatasource);
    });

    test('should not return failure if the get user throw UserNotFoundException ', () async {
      // Arrange
      mockCanNotGetUser();
      // Act
      var result = await repository.createUser(newUserParams);
      // Assert
      verify(mockDbDatasource.createUser(userCreateModel));
      expect(result, const Left(UserCreateFailure(["Can't get the user after creation"])));
    });

    test('should return failure if the creations fails', () async {
      // Arrange
      mockNotSaved();
      // Act
      var result = await repository.createUser(newUserParams);
      // Assert
      expect(result, const Left(UserCreateFailure(["User can't be created"])));
    });
  });

  group('getUserByEmail',(){
    void mockGreenScenarioGetUserByEmail(){
      when(mockDbDatasource.getUserByEmail(any)).thenAnswer((_)async=>userModel);
    }
    test('should call getEmailById from the db', () async {
      // Arrange
      mockGreenScenarioGetUserByEmail();
      // Act
      await repository.getUserByEmail(userModel.email);
      // Assert
      verify(mockDbDatasource.getUserByEmail(userModel.email));
    });
    test('should return the user', () async {
      // Arrange
      mockGreenScenarioGetUserByEmail();
      // Act
      var result = await repository.getUserByEmail(userModel.email);
      // Assert
      verify(mockDbDatasource.getUserByEmail(userModel.email));
      expect(result, Right(userModel));
    });

    test('should return failure if not found the user', () async {
      // Arrange
      when(mockDbDatasource.getUserByEmail(any)).thenThrow(UserNotFoundException());
      // Act
      var result = await repository.getUserByEmail(userModel.email);
      // Assert
      expect(result, Left(UserNotFoundFailure(['No user found for ${userModel.email}'])));
    });
  });

  group('getUserById',(){
    void mockGreenScenarioGetUserById(){
      when(mockDbDatasource.getUserById(any)).thenAnswer((_)async=>userModel);
    }
    test('should call getEmailById from the db', () async {
      // Arrange
      mockGreenScenarioGetUserById();
      // Act
      await repository.getUserById(1);
      // Assert
      verify(mockDbDatasource.getUserById(1));
    });
    test('should return the user', () async {
      // Arrange
      mockGreenScenarioGetUserById();
      // Act
      var result = await repository.getUserById(1);
      // Assert
      verify(mockDbDatasource.getUserById(1));
      expect(result, Right(userModel));
    });

    test('should return failure if not found the user', () async {
      // Arrange
      when(mockDbDatasource.getUserById(any)).thenThrow(UserNotFoundException());
      // Act
      var result = await repository.getUserById(1);
      // Assert
      expect(result, const Left(UserNotFoundFailure(['No user found with id 1'])));
    });
  });

  group('deleteUser', (){
    void mockGreenDelete(){
      when(mockDbDatasource.getUserById(any)).thenAnswer((_)async=>userModel);
      when(mockDbDatasource.deleteUser(any)).thenAnswer((_)async=>true);
    }


    test('should call the user before delete, then delete', () async {
      // Arrange
      mockGreenDelete();
      // Act
      await repository.deleteUser(1);
      // Assert
      verify(mockDbDatasource.getUserById(1));
      verify(mockDbDatasource.deleteUser(1));
    });
    test('should return true if delete is Ok', () async {
      // Arrange
      mockGreenDelete();
      // Act
      var result = await repository.deleteUser(1);
      // Assert
      verify(mockDbDatasource.getUserById(1));
      verify(mockDbDatasource.deleteUser(1));
      expect(result, Right(userModel));
    });

    test('should return  failure if the user can\'t be found', () async {
      // Arrange
      when(mockDbDatasource.getUserById(any)).thenThrow(UserNotFoundException());
      // Act
      var result = await repository.deleteUser(1);
      // Assert
      expect(result, Left(UserNotFoundFailure([repository.errorMsgNoId(1)])));
      verifyNever(mockDbDatasource.deleteUser(any));
    });
    test('should return  failure if can\'t delete', () async {
      // Arrange
      when(mockDbDatasource.getUserById(any)).thenAnswer((_)async=>userModel);
      when(mockDbDatasource.deleteUser(any)).thenAnswer((_)async=>false);
      // Act
      var result = await repository.deleteUser(1);
      // Assert
      expect(result, Left(DatabaseWriteFailure([repository.errorMsgDelete(1)])));
    });
  });

  group('updateUser', (){
    mockGreenScenario(){
      when(mockDbDatasource.updateUser(any))
          .thenAnswer((_)async=>true);
      when(mockDbDatasource.getUserById(any)).thenAnswer((_)async=>userModel);
    }
    test('should return the updated user if everything is fine', () async {
      // Arrange
      mockGreenScenario();
      // Act
      var result = await repository.updateUser(userModel);
      // Assert
      verify(mockDbDatasource.updateUser(userModel));
      verify(mockDbDatasource.getUserById(userModel.id));
      expect(result, Right(userModel));
    });

    test('should return  failure if the user can\'t didn\'t update', () async {
      // Arrange
      when(mockDbDatasource.updateUser(any)).thenAnswer((_)async=>false);
      // Act
      var result = await repository.updateUser(userModel);
      // Assert
      expect(result, Left(DatabaseWriteFailure([repository.errorMsgUpdate(1)])));
      verifyNever(mockDbDatasource.getUserById(any));
    });

    test('should return  failure if can\'t get the updated user', () async {
      // Arrange
      when(mockDbDatasource.getUserById(any)).thenThrow(UserNotFoundException());
      when(mockDbDatasource.updateUser(any)).thenAnswer((_)async=>true);
      // Act
      var result = await repository.updateUser(userModel);
      // Assert
      expect(result, Left(UserNotFoundFailure([repository.errorMsgNoId(1)])));
    });
  });

  group('getUserAuthCredentials', (){
    late String emailTest;
    late UserLoginCredentialsModel authModelTest;

    setUp((){
      emailTest = 'test@test.com';
      authModelTest = UserLoginCredentialsModel(
          email: emailTest, encryptedPassword: 'encryptedPassword');
    });
    test('should call the the getUserAuthCredentials', () async {
      // Arrange
      when(mockDbDatasource.getLoginCredentials(any)).thenAnswer((_)async=>authModelTest);
      // Act
      var result = await repository.getUserAuthCredentials(emailTest);
      // Assert
      expect(result, Right(authModelTest));
    });   
    test('should return Failure if the credentials is not found', () async {
      // Arrange
      when(mockDbDatasource.getLoginCredentials(any)).thenThrow(UserNotFoundException());
      // Act
      var result = await repository.getUserAuthCredentials(emailTest);
      // Assert
      expect(result, Left(UserNotFoundFailure([repository.errorMsgNoEmail(emailTest)])));
    });
  });

  group('changePassword', (){
    String newPassword = 'newPassword';
    void mockGreen(){
      when(mockDbDatasource.getUserByEmail(any)).thenAnswer((_)async=>userModel);
      when(mockDbDatasource.changePassword(any,any)).thenAnswer((_)async=>true);
    }
    void mockUserNotFound(){
      when(mockDbDatasource.getUserByEmail(any)).thenThrow(UserNotFoundException());
      when(mockDbDatasource.changePassword(any,any)).thenAnswer((_)async=>true);
    }
    void mockChangeFails(){
      when(mockDbDatasource.getUserByEmail(any)).thenAnswer((_)async=>userModel);
      when(mockDbDatasource.changePassword(any,any)).thenAnswer((_)async=>false);
    }
    test('should return the changed password if the change success ', () async {
      // Arrange
      mockGreen();
      // Act
      var result = await repository.changePassword(userModel.email, newPassword);
      // Assert
      expect(result, Right(newPassword));
    });

    test('should return failure if the user is not found', () async {
      // Arrange
      mockUserNotFound();
      // Act
      var result = await repository.changePassword(userModel.email, newPassword);
      // Assert
      expect(result, Left(UserNotFoundFailure([repository.errorMsgNoEmail(userModel.email)])));
    });
    test('should return failure if the change fails', () async {
      // Arrange
      mockChangeFails();
      // Act
      var result = await repository.changePassword(userModel.email, newPassword);
      // Assert
      expect(result,  Left(DatabaseWriteFailure([repository.errorMsgPasswordChange(userModel.id)])));
    });
  });

  group('cacheCurrentUser', (){
    test('should return the catch id', () async {
      // Arrange
      // Act
      var result = await repository.cacheCurrentUser(userModel.id);
      // Assert
      expect(result, Right(userModel.id));
    });
    test('should return failure if the cache fails', () async {
      // Arrange
      when(mockPrefDatasource.cache(any)).thenThrow(CacheException());
      // Act
      var result = await repository.cacheCurrentUser(userModel.id);
      // Assert
      expect(result, const Left(CacheFailure([])));
    });
  });

  group('getCurrentUserId', (){
    test('should return the catch id', () async {
      // Arrange
      when(mockPrefDatasource.getCurrentUserId())
          .thenAnswer((_)=>userModel.id);
      // Act
      var result = await repository.getCurrentUserId();
      // Assert
      expect(result, Right(userModel.id));
    });
    test('should return failure if reading cache fails', () async {
      // Arrange
      when(mockPrefDatasource.getCurrentUserId()).thenThrow(CacheException());
      // Act
      var result = await repository.getCurrentUserId();
      // Assert
      expect(result, const Left(CacheFailure([])));
    });
  });
}