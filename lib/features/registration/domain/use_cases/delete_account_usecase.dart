import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteAccountUsecase extends UseCase<void, UserDeleteParams> {
  UserRepository repository;

  DeleteAccountUsecase(this.repository);

  @override
  Future<Result<void>> call(UserDeleteParams params) {
    return repository.logout();
  }

}

class UserDeleteParams extends Equatable{
  final int id;

  const UserDeleteParams(this.id);

  @override
  List<Object?> get props => [id];
}
