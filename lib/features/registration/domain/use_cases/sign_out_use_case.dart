
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class SignOutUseCase extends UseCase<void, NoParams>{
  final UserRepository repository;
  SignOutUseCase(this.repository);

  @override
  Future<Result<void>> call(NoParams params) {
    return repository.logout();
  }
}