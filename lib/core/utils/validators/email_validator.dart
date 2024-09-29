import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/core/utils/validators/input_validator.dart';


class EmailValidator extends InputValidator<String, String> {
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  static const String emptyError = 'Email should not be empty';
  static const String wrongFormat = 'Invalid email format';

  @override
  Result<String> validate(String value) {
    if (value.isEmpty) {
      return Result.failure(const InvalidInputFailure([emptyError]));
    } else if (!_emailRegExp.hasMatch(value)) {
      return Result.failure(const InvalidInputFailure([wrongFormat]));
    }
    return Result.success(value);
  }
}