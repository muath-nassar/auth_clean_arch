part of 'verify_email_bloc.dart';

sealed class VerifyEmailState extends Equatable {
  const VerifyEmailState();
}

final class VerifyEmailInitial extends VerifyEmailState {
  @override
  List<Object> get props => [];
}
