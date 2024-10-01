import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';


class ForgetPasswordUseCase extends UseCase<bool, ForgetPasswordParams> {
  final UserRepository repository;

  ForgetPasswordUseCase(this.repository);

  @override
  Future<Result<bool>> call(params) {
    return repository.changePassword(params.id, params.password);
  }
}

class ForgetPasswordParams extends Equatable{
  final int id;
  final String password;

  const ForgetPasswordParams({required this.id, required this.password});

  @override
  List<Object?> get props => [id, password];
}

