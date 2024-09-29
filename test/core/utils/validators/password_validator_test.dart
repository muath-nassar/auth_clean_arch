import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/core/utils/validators/input_validator.dart';
import 'package:auth_clean_arch/core/utils/validators/password_validator.dart';
import 'package:flutter_test/flutter_test.dart';

main(){
  late InputValidator passwordValidator;
  setUp((){
    passwordValidator = PasswordValidator();
  });

  test('password should be 8 and more in length', (){
    String password = '1234';
    var result = passwordValidator.validate(password);
    expect(result, Result<String>.failure(const InvalidInputFailure([PasswordValidator.errorLength,PasswordValidator.errorLowercase,PasswordValidator.errorUppercase])));
  });
  test('password should have at least one number', (){
    String password = 'aaaAAAaaaAAAaAa';
    var result = passwordValidator.validate(password);
    expect(result,  Result<String>.failure(const InvalidInputFailure(['Password should have at least one number.'])));
  });

  test('password should have at least one lowercase', (){
    String password = '1234AAAAAA';
    var result = passwordValidator.validate(password);
    expect(result,  Result<String>.failure(const InvalidInputFailure(['Password should have at least one lowercase letter.'])));
  });
  test('password should have at least one uppercase', (){
    String password = '1234aaaaaaa';
    var result = passwordValidator.validate(password);
    expect(result,  Result<String>.failure(const InvalidInputFailure(['Password should have at least one uppercase letter.'])));
  });
    test('password should pass', (){
    String password = '12aaAAgghfh';
    var result = passwordValidator.validate(password);
    expect(result, Result<String>.success(password));
  });



}