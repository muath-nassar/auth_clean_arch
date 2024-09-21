import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../entities/user.dart';

class LoginUseCase extends UseCase<User, LoginParams>{
  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    throw UnimplementedError();
  }

}

/// This entity is related to the needed data for authentication.
class LoginParams extends Equatable{
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [email, password];
}