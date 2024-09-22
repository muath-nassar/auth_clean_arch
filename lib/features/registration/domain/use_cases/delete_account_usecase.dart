import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAccountUsecase extends UseCase<User, NoParams> {
  UserRepository repository;

  DeleteAccountUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    var currentUserIdCall = await repository.getCurrentUserId();
    return currentUserIdCall.fold((failure) => Left(failure),
        (currentUserId) async {
      return repository.deleteUser(currentUserId);
    });
  }
}
