import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

import '../entities/user.dart';

class GetUserUsingEmailUsecase extends UseCase<User, EmailParams>{
  UserRepository repository;
  GetUserUsingEmailUsecase(this.repository);
  @override
  Future<Result<User>> call(EmailParams params) {
    return repository.getUserByEmail(params.email);
  }

}


class EmailParams extends Equatable{
  final String email;

  const EmailParams(this.email);

  @override
  List<Object?> get props => [email];
}