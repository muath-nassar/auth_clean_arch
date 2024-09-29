import 'package:auth_clean_arch/core/result/result.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';


class ForgetPasswordUseCase extends UseCase<String, ForgetPasswordParams> {
  @override
  Future<Result<String>> call(params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class ForgetPasswordParams extends Equatable{

  final String email;

  const ForgetPasswordParams(this.email);

  @override
  List<Object?> get props => [email];
}

