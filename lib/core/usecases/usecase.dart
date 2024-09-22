import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Params>{
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}

class EmailParams extends Equatable {
  final String email;

  const EmailParams({required this.email});

  @override
  List<Object?> get props => [email];
}

String generateRandomCode() {
  String code = '';
  List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  numbers.shuffle();
  for (int i = 0; i <= 5; i++) {
    code = code + numbers[i].toString();
  }
  return code;
}

bool verifyCode(String inputCode, String? sentCode,DateTime? sentTime, int waitingTimeInMin) {
  if (sentTime == null) {
    return false;
  }
  var difference =
      DateTime.now().difference(sentTime).inSeconds ;
  if (difference >= waitingTimeInMin*60) {
    return false;
  }
  return inputCode == sentCode;
}