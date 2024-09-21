import 'package:bcrypt/bcrypt.dart';
class PasswordHashingUtil{

  String hash(String password){
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  bool verifyPassword(String inputPassword,String hashedPassword){
    return BCrypt.checkpw(inputPassword, hashedPassword);
  }
}