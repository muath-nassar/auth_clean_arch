part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}


final class SignOutRequest extends HomeEvent{
  @override
  List<Object?> get props => [];
}

final class DeleteUserRequest extends HomeEvent{
  final int userId;

  const DeleteUserRequest(this.userId);

  @override
  List<Object?> get props => [userId];
}