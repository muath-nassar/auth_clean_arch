import 'package:dartz/dartz.dart';
import '../../errors/failures.dart';

abstract class InputValidator<InputType,ReturnType>{
  Either<Failure, ReturnType> validate(InputType value);
}