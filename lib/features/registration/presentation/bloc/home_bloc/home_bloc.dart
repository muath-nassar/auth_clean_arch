import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/use_cases/delete_account_usecase.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  SignOutUseCase signOutUseCase;
  DeleteAccountUsecase deleteAccountUseCase;
  HomeBloc(this.signOutUseCase,this.deleteAccountUseCase) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      if(event is SignOutRequest){
       await _onSignOut(event,emit);
      }
      if(event is DeleteUserRequest){
        await _onDelete(event,emit);
      }
    });
  }

  Future<void> _onSignOut(SignOutRequest event, Emitter<HomeState> emit)async {
    await signOutUseCase(NoParams());
    emit(SignedOut());
  }

  Future<void>_onDelete(DeleteUserRequest event, Emitter<HomeState> emit) async{
    emit(Loading());
    var action = await deleteAccountUseCase( UserDeleteParams(event.userId)) ;
    if(action.isSuccess()){
      emit(UserDeleted());
    }else{
      emit(UserDeleteError(action.failure!));
    }
  }
}
