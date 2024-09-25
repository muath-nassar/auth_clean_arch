import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/validators/input_validator.dart';
import 'package:dartz/dartz.dart';
//
// class PasswordValidator extends InputValidator<String, String> {
//   static const String errorLength = 'Password should be 8 characters or more.';
//   static const String errorNumber = 'Password should have at least one number.';
//   static const String errorLowercase =
//       'Password should have at least one uppercase letter.';
//   static const String errorUppercase =
//       'Password should have at least one uppercase letter.';
//
//   @override
//   Either<Failure, String> validate(String value) {}
// }
class PasswordValidator extends InputValidator<String, String> {
  static const String errorLength = 'Password should be 8 characters or more.';
  static const String errorNumber = 'Password should have at least one number.';
  static const String errorLowercase =
      'Password should have at least one lowercase letter.';
  static const String errorUppercase =
      'Password should have at least one uppercase letter.';

  @override
  Either<Failure, String> validate(String value) {
    List<String> errors = [];

    // Check length
    if (value.length < 8) {
      errors.add(errorLength);
    }

    // Check if contains at least one number
    if (!_hasNumber(value)) {
      errors.add(errorNumber);
    }

    // Check if contains at least one lowercase letter
    if (!_hasLowercase(value)) {
      errors.add(errorLowercase);
    }

    // Check if contains at least one uppercase letter
    if (!_hasUppercase(value)) {
      errors.add(errorUppercase);
    }

    // Return failure if there are any validation errors
    if (errors.isNotEmpty) {
      return Left(InvalidInputFailure(errors));
    }

    // If no errors, return the validated password
    return Right(value);
  }

  // Helper function to check if the password contains at least one number
  bool _hasNumber(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }

  // Helper function to check if the password contains at least one lowercase letter
  bool _hasLowercase(String value) {
    return value.contains(RegExp(r'[a-z]'));
  }

  // Helper function to check if the password contains at least one uppercase letter
  bool _hasUppercase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }
}