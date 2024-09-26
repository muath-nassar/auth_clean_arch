part of 'verify_email_bloc.dart';

sealed class VerifyEmailState extends Equatable {
  const VerifyEmailState();
}

final class VerifyEmailInitial extends VerifyEmailState {
  @override
  List<Object> get props => [];
}
//--------------Sending States----------
final class InvalidEmail extends VerifyEmailState{
  final Failure failure;
  const InvalidEmail(this.failure);
  @override
  List<Object?> get props => [failure];
}

final class Sending extends VerifyEmailState{
  @override
  List<Object?> get props => [];
}

final class SendError extends VerifyEmailState{
  final Failure failure;
  const SendError(this.failure);
  @override
  List<Object?> get props => [failure];
}

final class SendSuccess extends VerifyEmailState{
  @override
  List<Object?> get props => [];
}


//-------------- Verifying Code states------------

final class UnverifiedEmail extends VerifyEmailState{
  final Failure failure;
  const UnverifiedEmail(this.failure);
  @override
  List<Object?> get props => [failure];
}
final class VerifiedEmail extends VerifyEmailState{
  @override
  List<Object?> get props => [];
}