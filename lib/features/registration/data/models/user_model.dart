
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> userJson){
    // Check if all required fields are present
    if (!userJson.containsKey('id') || !userJson.containsKey('email') ||
        !userJson.containsKey('firstName') || !userJson.containsKey('lastName')) {
      throw const FormatException('Missing required fields in JSON');
    }

    // Check if the values are of the correct type
    if (userJson['id'] is! int || userJson['email'] is! String ||
        userJson['firstName'] is! String || userJson['lastName'] is! String) {
      throw const FormatException('Invalid type for one or more fields in JSON');
    }
    return UserModel(
        id: userJson['id'],
        email: userJson['email'],
        firstName: userJson['firstName'],
        lastName: userJson['lastName']);
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

}
