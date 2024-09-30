
import 'package:hive/hive.dart';

import '../../domain/entities/user.dart';

@HiveType(typeId: 0)
class UserModel extends User with HiveObjectMixin{
  UserModel({
    @HiveField(0)
    required super.id,
    @HiveField(1)
    required super.email,
    @HiveField(2)
    required super.firstName,
    @HiveField(3)
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
