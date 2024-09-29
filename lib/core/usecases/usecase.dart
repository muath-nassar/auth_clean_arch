import 'package:equatable/equatable.dart';
import '../result/result.dart';

abstract class UseCase<Type, Params>{
  Future<Result<Type>> call(Params params);
}

class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}

