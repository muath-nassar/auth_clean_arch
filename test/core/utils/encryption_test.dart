import 'dart:math';

import 'package:auth_clean_arch/core/utils/encryption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


main(){
  late String correctPassword;
  late String wrongPassword;
  late PasswordHashingUtil hashUtil;
  Random random;
  setUp((){
    random = Random();
    hashUtil = PasswordHashingUtil();
    const String upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>? ';
    const String allCharsString =
        upperCaseLetters + lowerCaseLetters + numbers + specialChars;
    List<String> allCharsList = allCharsString.split('');
    allCharsList.shuffle();
    String randomCharacters = allCharsList.join('');

    correctPassword =
    randomCharacters.substring(randomCharacters.length -
        random.nextInt(randomCharacters.length - 16));

    wrongPassword = 'wrongPassword';

  });
  test('should return true if the password matches', ()async{
    var hashed = hashUtil.hash(correctPassword);
    debugPrint('The password is $correctPassword\n hash is $hashed');
    expect(hashUtil.verifyPassword(correctPassword, hashed), true);
  });

  test('should return false if the password does not matches', ()async{
    var hashed = hashUtil.hash(correctPassword);
    expect(hashUtil.verifyPassword(wrongPassword, hashed), false);
  });
}