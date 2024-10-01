import 'package:equatable/equatable.dart';

class User extends Equatable{
  int? id;
  String? email;
  String? firstName;
  String? lastName;


  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,

});

  @override
  List<Object?> get props => [id,email,firstName,lastName];
}



