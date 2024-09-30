
import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

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
