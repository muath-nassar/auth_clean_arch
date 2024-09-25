import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable{
  final List<String> errors;
  const Failure(this.errors);
  @override
  List<Object?> get props => errors;
}

class UserCreateFailure extends Failure{
  const UserCreateFailure(super.errors);
}

class UserNotFoundFailure extends Failure{
  const UserNotFoundFailure(super.errors);
}

class WrongCredentialsFailure extends Failure{
  const WrongCredentialsFailure(super.errors);
}

class EmailNotVerifiedFailure extends Failure{
  const EmailNotVerifiedFailure(super.errors);
}

class CacheFailure extends Failure {
  const CacheFailure(super.errors);
}

class DatabaseReadFailure extends Failure{
  const DatabaseReadFailure(super.errors);
}
class DatabaseWriteFailure extends Failure{
  const DatabaseWriteFailure(super.errors);
}

class EmailFailure extends Failure{
  const EmailFailure(super.errors);
}

class VerificationCodeFailure extends Failure{
  const VerificationCodeFailure(super.errors);
}

class InvalidInputFailure extends Failure{
  const InvalidInputFailure(super.errors);

}


