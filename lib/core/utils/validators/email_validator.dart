import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/validators/input_validator.dart';
import 'package:dartz/dartz.dart';


class EmailValidator extends InputValidator<String, String> {
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  static const String emptyError = 'Email should not be empty';
  static const String wrongFormat = 'Invalid email format';

  @override
  Either<Failure, String> validate(String value) {
    print('a');
    if (value.isEmpty) {
      print('b');
      return const Left(InvalidInputFailure([emptyError]));
    } else if (!_emailRegExp.hasMatch(value)) {
      print('c');
      return const Left(InvalidInputFailure([wrongFormat]));
    }
    print('d');
    return Right(value);
  }
}