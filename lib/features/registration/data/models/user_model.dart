
import 'package:hive/hive.dart';

import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends User with HiveObjectMixin {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? firstName;

  @HiveField(3)
  final String? lastName;

  UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
  }) : super(id: id, email: email, firstName: firstName, lastName: lastName);

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
