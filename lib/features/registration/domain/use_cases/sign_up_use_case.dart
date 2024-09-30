import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignUpUseCase extends UseCase<User,UserCreateParams>{
  final UserRepository repository;
  SignUpUseCase(this.repository);

  @override
  Future<Result<User>> call(UserCreateParams params) {
    return repository.createUser(
        params.email, params.password, params.firstName, params.lastName);
  }
}

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