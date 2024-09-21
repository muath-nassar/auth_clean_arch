import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../entities/user.dart';

class SignUpUseCase extends UseCase<User,UserCreateParams>{
  final UserRepository repository;
  SignUpUseCase(this.repository);
  @override
  Future<Either<Failure, User>> call(UserCreateParams params) async{
    return await repository.createUser(params);
  }


}

/// UserCreateDTO class is used to get the data needed to create a new user.
class UserCreateParams extends  Equatable{
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  const UserCreateParams({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });
  @override
  List<Object?> get props => [email,firstName,lastName,password];
}