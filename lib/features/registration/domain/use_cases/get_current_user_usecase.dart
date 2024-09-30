import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';

class GetCurrentUserUsecase extends UseCase<User, NoParams>{
  final UserRepository repository;

  GetCurrentUserUsecase(this.repository);
  @override
  Future<Result<User>> call(NoParams params) {
    return repository.getCurrentUser();
  }

}



