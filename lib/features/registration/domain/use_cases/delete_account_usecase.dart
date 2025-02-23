
import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class DeleteAccountUsecase extends UseCase<User, UserDeleteParams> {
  UserRepository repository;

  DeleteAccountUsecase(this.repository);

  @override
  Future<Result<User>> call(UserDeleteParams params) {
    return repository.deleteUser(params.id);
  }

}

class UserDeleteParams extends Equatable{
  final int id;

  const UserDeleteParams(this.id);

  @override
  List<Object?> get props => [id];
}
