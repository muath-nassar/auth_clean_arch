import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable{
  final List<String> errors;
  const Failure(this.errors);
  @override
  List<Object?> get props => errors;
}

class EmailExistsFailure extends Failure{
  const EmailExistsFailure(super.errors);
}
