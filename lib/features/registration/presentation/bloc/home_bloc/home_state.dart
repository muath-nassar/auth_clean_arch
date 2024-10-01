part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

final class SignedOut extends HomeState{
  @override
  List<Object?> get props => [];
}


final class UserDeleted extends HomeState{
  @override
  List<Object?> get props => [];
}

final class Loading extends HomeState{
  @override
  List<Object?> get props => [];
}

final class UserDeleteError extends HomeState{
  final Failure failure;

  const UserDeleteError(this.failure);
  @override
  List<Object?> get props => [];
}
