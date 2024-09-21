import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class SignOutUseCase extends UseCase<int, NoParams>{
  final UserRepository repository;
  SignOutUseCase(this.repository);
  @override
  Future<Either<Failure, int>> call(NoParams params){
    return repository.cacheCurrentUser(0);
  }

}