import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/data/models/user_model.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/encryption.dart';
import '../entities/user.dart';


class LoginUseCase extends UseCase<User, LoginParams> {
  final UserRepository repository;
  final PasswordHashingUtil hashUtil;

  LoginUseCase({required this.repository, required this.hashUtil});

  @override
  Future<Result<User>> call(LoginParams params) {
    return repository.login(params.email, params.password);
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
