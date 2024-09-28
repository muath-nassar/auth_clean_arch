import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_model.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/encryption.dart';
import '../entities/user.dart';

/// The call in this class returns the Right([User]) if the authentication succeeds
/// However, it returns Left([WrongCredentialsFailure]) if the authentication failed.
/// If the email is not found in users table return Left([UserNotFoundFailure])
/// also, return  Left([UserNotFoundFailure]) if getUserByEmail Fails for any reason.
/// If the email is not verified return Left([EmailNotVerifiedFailure])
/// If caching the current user fails return lef([CacheFailure])
class LoginUseCase extends UseCase<User, LoginParams> {
  final UserRepository repository;
  final PasswordHashingUtil hashUtil;

  LoginUseCase({required this.repository, required this.hashUtil});

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    var userCredentialsRequest =
        await repository.getUserAuthCredentials(params.email);
    return userCredentialsRequest.fold((failure) => Left(failure),
        (credentials) async {
      if (hashUtil.verifyPassword(
          params.password, credentials.encryptedPassword)) {
        var getUserCall = await repository.getUserByEmail(params.email);
        return getUserCall.fold((getUerFail) => Left(getUerFail), (user) async{
          if (user.emailVerified) {
            var cacheCall = await repository.cacheCurrentUser(user.id);
            return cacheCall.fold(
                (cacheFailure) => Left(cacheFailure),
                (id) async {
                  DateTime newLoginTime = DateTime.now();
                  UserModel userModel = UserModel.fromUser(user);
                  UserModel newUserModel = UserModel(id: userModel.id, email: userModel.email, firstName: userModel.firstName, lastName: userModel.lastName, createTime: userModel.createTime, lastLogin: newLoginTime, emailVerified: userModel.emailVerified);
                  await repository.updateUser(newUserModel);
                  var newLoginUpdated = await repository.getUserById(user.id);
                  late User updatedUser;
                  newLoginUpdated.fold((_){}, (u){updatedUser = u;});
                  return Right(updatedUser);
                });
          }
          return Left(EmailNotVerifiedFailure(['${user.email} is not verified.']));
        });
      }
      return const Left(WrongCredentialsFailure(['Please check your provided email and password.']));
    });
  }
}

/// This entity is related to the needed data for authentication.
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
