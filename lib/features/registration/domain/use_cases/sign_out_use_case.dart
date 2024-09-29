import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';

class SignOutUseCase extends UseCase<void, NoParams>{
  final UserRepository repository;
  SignOutUseCase(this.repository);

  @override
  Future<Result<void>> call(NoParams params) {
    return repository.logout();
  }



}