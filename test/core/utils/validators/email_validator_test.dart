import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/utils/validators/email_validator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

main(){
  late EmailValidator emailValidator;
  setUp((){
    emailValidator = EmailValidator();
  });
  group('Green', (){
    String email = 'moad@gmail.com';
    test('should return the email', (){
      var result = emailValidator.validate(email);
      expect(result, Right(email));
    });
  });  
  
  group('Red', (){
    test('should return failure for empty', (){
      var result = emailValidator.validate('');
      expect(result,const Left(InvalidInputFailure([EmailValidator.emptyError])));
    });

    test('should return failure for wrong format', (){
      var result = emailValidator.validate('moadsdf.com');
      expect(result,const Left(InvalidInputFailure([EmailValidator.wrongFormat])));
    });
  });
}