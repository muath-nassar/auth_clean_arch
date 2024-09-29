import 'package:auth_clean_arch/core/result/result.dart';

abstract class InputValidator<InputType,ReturnType>{
  Result<ReturnType> validate(InputType value);
}