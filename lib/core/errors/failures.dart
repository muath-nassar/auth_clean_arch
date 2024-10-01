import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable{
  final List<Object?> errors;
  const Failure(this.errors);
  @override
  List<Object?> get props => errors;
}

class UserCreateFailure extends Failure{
  const UserCreateFailure(super.errors);
}

class WrongCredentialsFailure extends Failure{
  const WrongCredentialsFailure(super.errors);
}


class InvalidInputFailure extends Failure{
  const InvalidInputFailure(super.errors);
}

class NetworkFailure extends Failure{
  const NetworkFailure(super.errors);
}

class FormatFailure extends Failure{
  const FormatFailure(super.errors);
}


class ServerFailure extends Failure{
  const ServerFailure(super.errors);
}

class NoCachedUserFailure extends Failure{
  const NoCachedUserFailure(super.errors);

}


