import 'dart:convert';

import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/network.dart';
import '../../domain/entities/user.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

abstract class RemoteUserDataSource {

  /// Throws [NetworkException] if Offline
  Future<User> getUser(int userId);

  /// Throws [NetworkException] if Offline
  Future<User> login(String email, String password);

  /// Throws [NetworkException] if Offline
  Future<User> updateUser(int userId, User updatedUser);

  /// Throws [NetworkException] if Offline
  Future<bool> changePassword(int userId, String newPassword);

  /// Throws [UserCreateException] if the user can't be created
  /// Throws [NetworkException] if Offline
  Future<User> createUser(
      String email, String password, String firstName, String lastName);

  /// Throws [NetworkException] if Offline
  Future<User> deleteUser(int id);
}

Map<String, String> headers = {'Content-Type': 'application/json'};
String baseUrl =
    "https://mock_1c7ce115331f482cb2056882974f7a57.mock.insomnia.rest/";

class RemoteUserDatasourceImp extends RemoteUserDataSource {
  NetworkInfo networkInfo;
  http.Client httpClient;

  RemoteUserDatasourceImp({required this.httpClient,required this.networkInfo});

  Future<void> _networkExceptionHandling() async {
    if(await networkInfo.isConnected == false) throw NetworkException();
  }

  /// Throws [UserCreateException] if the user can't be created
  /// Throws [NetworkException] if Offline
  @override
  Future<User> createUser(String email, String password, String firstName, String lastName) async {
    await _networkExceptionHandling();
    Uri url = Uri.parse("${baseUrl}users/signup");
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
    var response = await httpClient.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      try{
        return UserModel.fromJson(json.decode(response.body));
      }on FormatException catch(e){
        debugPrint(e.message);
        throw UserCreateException();
      }
    }
    throw UserCreateException();
  }

  @override
  Future<User> login(String email, String password) async {
    await _networkExceptionHandling();
    Uri url = Uri.parse("${baseUrl}users/login");
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };
    var response = await httpClient.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }

  @override
  Future<bool> changePassword(int userId, String newPassword) async {
    await _networkExceptionHandling();
    Uri url = Uri.parse("${baseUrl}users/$userId/change-password");
    Map<String, dynamic> body = {
      'id': userId,
      'password': newPassword,
    };
    var response = await httpClient.patch(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      if (response.body == 'true'){
        return true;
      }
      return false;
    }
    throw ServerException();

  }

  @override
  Future<User> deleteUser(int id) async {
    await _networkExceptionHandling();
    Uri url = Uri.parse("${baseUrl}users/$id/delete");
    Map<String, dynamic> body = {
      'id': id,
    };
    var response = await httpClient.delete(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }

  @override
  Future<User> getUser(int userId) async {
    await _networkExceptionHandling();
    Uri url = Uri.parse("${baseUrl}users/$userId");

    var response = await httpClient.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }

  @override
  Future<User> updateUser(int userId, User updatedUser) async {
    await _networkExceptionHandling();
    Uri url = Uri.parse("${baseUrl}users/$userId/update");
    Map<String, dynamic> body = {
      'email': updatedUser.email,
      'firstName': updatedUser.firstName,
      'lastName': updatedUser.lastName,
    };
    var response = await httpClient.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }
}
