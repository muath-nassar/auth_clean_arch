import 'dart:convert';
import 'package:auth_clean_arch/core/network/network.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/remote_user_datasource.dart';
import 'package:auth_clean_arch/core/errors/exceptions.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'remote_datasource_test.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([http.Client, NetworkInfo])
void main() {
  late MockClient mockClient;
  late MockNetworkInfo mockNetworkInfo;
  late RemoteUserDataSource dataSource;

  const String baseUrl = 'https://mock_1c7ce115331f482cb2056882974f7a57.mock.insomnia.rest/';
  final Map<String, String> headers = {'Content-Type': 'application/json'};
  const String email = 'test@test.com';
  const String firstName = 'John';
  const String lastName = 'Doe';
  const String password = 'password123';
  const id = 1;

  setUp(() {
    mockClient = MockClient();
    mockNetworkInfo = MockNetworkInfo();
    dataSource = RemoteUserDatasourceImp(networkInfo: mockNetworkInfo, httpClient: mockClient);
  });

  group('createUser', () {
    final Uri url = Uri.parse('${baseUrl}users/signup');
    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };

    test('should perform a POST request with correct URL, headers, and body', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(fixture('user_json.json'), 201));

      // Act
      await dataSource.createUser(email, password, firstName, lastName);

      // Assert
      verify(mockClient.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      ));
    });

    test('should return User when the response code is 201 (created)', () async {
      // Arrange
      final responseJson = fixture('user_json.json');
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(responseJson, 201));

      // Act
      final result = await dataSource.createUser(email, password, firstName, lastName);

      // Assert
      expect(result, isA<User>());
      expect(result.email, email);
      expect(result.firstName, firstName);
      expect(result.lastName, lastName);
    });

    test('should throw a UserCreateException when the response code is not 201', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"error": "User already exists"}', 400));

      // Act
      final call = dataSource.createUser;

      // Assert
      expect(() => call(email, password, firstName, lastName), throwsA(isA<UserCreateException>()));
    });

    test('should throw a UserCreateException when the response is not valid JSON', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Not a JSON response', 201));

      // Act
      final call = dataSource.createUser;

      // Assert
      expect(() => call(email, password, firstName, lastName), throwsA(isA<UserCreateException>()));
    });

    test('should throw a UserCreateException when there is a network error', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>false);

      // Act
      final call = dataSource.createUser;

      // Assert
      expect(() => call(email, password, firstName, lastName), throwsA(isA<NetworkException>()));
    });

  });

  group('login', (){
    final Uri url = Uri.parse('${baseUrl}users/login');
    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    test('should perform a POST request with correct URL, headers, and body', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(fixture('user_json.json'), 200));

      // Act
      await dataSource.login(email, password);

      // Assert
      verify(mockClient.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      ));
    });

    test('should return User when the response code is 200', () async {
      // Arrange
      final responseJson = fixture('user_json.json');
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(responseJson, 200));

      // Act
      final result = await dataSource.login(email, password);

      // Assert
      expect(result, isA<User>());
      expect(result.email, email);
      expect(result.firstName, firstName);
      expect(result.lastName, lastName);
    });

    test('should throw a ServerException when the response code is not 200', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"error": "User already exists"}', 400));

      // Act
      final call = dataSource.login;

      // Assert
      expect(() => call(email, password), throwsA(isA<ServerException>()));
    });

    test('should throw a FormatException when the response is not valid JSON', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Not a JSON response', 200));

      // Act
      final call = dataSource.login;

      // Assert
      expect(() => call(email, password), throwsA(isA<FormatException>()));
    });

    test('should throw a NetworkException when there is a network error', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>false);

      // Act
      final call = dataSource.login;

      // Assert
      expect(() => call(email, password), throwsA(isA<NetworkException>()));
    });

  });

  group('changePassword', (){
    final Uri url = Uri.parse('${baseUrl}users/1/change-password');
    final Map<String, dynamic> requestBody = {
      'id': id,
      'password': password,
    };

    test('should perform a PATCH request with correct URL, headers, and body', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.patch(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('true', 200));

      // Act
      await dataSource.changePassword(id, password);

      // Assert
      verify(mockClient.patch(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      ));
    });

    test('should return true when the response code is 200', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.patch(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('true', 200));

      // Act
      final result = await dataSource.changePassword(id, password);

      // Assert
      expect(result, true);
    });

    test('should throw a ServerException when the response code is not 200', () async {
      // Arrange

      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.patch(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"error": "User already exists"}', 400));


      // Act
      final call = dataSource.changePassword;

      // Assert
      expect(() => call(id, password), throwsA(isA<ServerException>()));
    });

    test('should throw a NetworkException when there is a network error', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>false);

      // Act
      final call = dataSource.changePassword;

      // Assert
      expect(() => call(id, password), throwsA(isA<NetworkException>()));
    });

  });

  group('deletePassword', (){
    final Uri url = Uri.parse('${baseUrl}users/$id/delete');
    final Map<String, dynamic> requestBody = {
      'id': id,
    };

    test('should perform a DELETE request with correct URL, headers, and body', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.delete(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(fixture('user_json.json'), 200));

      // Act
      await dataSource.deleteUser(id);

      // Assert
      verify(mockClient.delete(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      ));
    });

    test('should return User when the response code is 200', () async {
      // Arrange
      final responseJson = fixture('user_json.json');
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.delete(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(responseJson, 200));

      // Act
      final result = await dataSource.deleteUser(id);

      // Assert
      expect(result, isA<User>());
      expect(result.email, email);
      expect(result.firstName, firstName);
      expect(result.lastName, lastName);
    });

    test('should throw a ServerException when the response code is not 200', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.delete(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"error": "User already exists"}', 400));

      // Act
      final call = dataSource.deleteUser;

      // Assert
      expect(() => call(id), throwsA(isA<ServerException>()));
    });


    test('should throw a NetworkException when there is a network error', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>false);

      // Act
      final call = dataSource.login;

      // Assert
      expect(() => call(email, password), throwsA(isA<NetworkException>()));
    });

  });

  group('getUser', (){
    final Uri url = Uri.parse('${baseUrl}users/$id');

    test('should perform a GET request with correct URL, headers, and body', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.get(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(fixture('user_json.json'), 200));

      // Act
      await dataSource.getUser(id);

      // Assert
      verify(mockClient.get(
        url,
        headers: headers,
      ));
    });

    test('should return User when the response code is 200', () async {
      // Arrange
      final responseJson = fixture('user_json.json');
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(responseJson, 200));

      // Act
      final result = await dataSource.getUser(id);

      // Assert
      expect(result, isA<User>());
      expect(result.email, email);
      expect(result.firstName, firstName);
      expect(result.lastName, lastName);
    });

    test('should throw a ServerException when the response code is not 200', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{"error": "User already exists"}', 400));

      // Act
      final call = dataSource.getUser;

      // Assert
      expect(() => call(id), throwsA(isA<ServerException>()));
    });

    test('should throw a FormatException when the response is not valid JSON', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not a JSON response', 200));

      // Act
      final call = dataSource.getUser;

      // Assert
      expect(() => call(id), throwsA(isA<FormatException>()));
    });

    test('should throw a NetworkException when there is a network error', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>false);

      // Act
      final call = dataSource.getUser;

      // Assert
      expect(() => call(id), throwsA(isA<NetworkException>()));
    });

  });

  group('update', (){
    final Uri url = Uri.parse('${baseUrl}users/$id/update');
    final Map<String, dynamic> requestBody = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
    User updatedUser =  User(id: id, email: email, firstName: firstName, lastName: lastName);
    test('should perform a PUT request with correct URL, headers, and body', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.put(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(fixture('user_json.json'), 200));

      // Act
      await dataSource.updateUser(id, updatedUser);

      // Assert
      verify(mockClient.put(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      ));
    });

    test('should return User when the response code is 200', () async {
      // Arrange
      final responseJson = fixture('user_json.json');
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(responseJson, 200));

      // Act
      final result = await dataSource.updateUser(id, updatedUser);

      // Assert
      expect(result, isA<User>());
      expect(result.email, email);
      expect(result.firstName, firstName);
      expect(result.lastName, lastName);
    });

    test('should throw a ServerException when the response code is not 200', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"error": "User already exists"}', 400));

      // Act
      final call = dataSource.updateUser;

      // Assert
      expect(() => call(id, updatedUser), throwsA(isA<ServerException>()));
    });

    test('should throw a FormatException when the response is not valid JSON', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>true);
      when(mockClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Not a JSON response', 200));

      // Act
      final call = dataSource.updateUser;

      // Assert
      expect(() => call(id, updatedUser), throwsA(isA<FormatException>()));
    });

    test('should throw a NetworkException when there is a network error', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async=>false);

      // Act
      final call = dataSource.login;

      // Assert
      expect(() => call(email, password), throwsA(isA<NetworkException>()));
    });

  });

}