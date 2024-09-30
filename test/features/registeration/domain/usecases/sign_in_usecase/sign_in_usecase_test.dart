import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_usecase_test.mocks.dart';


@GenerateMocks([UserRepository])
main() {
  late MockUserRepository mockUserRepository;
  late LoginUseCase loginUseCase;
  User testUser = const User(
      id: 1,
      email: 'test@test.com',
      firstName: 'firstName',
      lastName: 'lastName');

  setUp(() {
    mockUserRepository = MockUserRepository();
    loginUseCase = LoginUseCase(mockUserRepository);
  });

  test('should sign in using the repository', () async {
    // Arrange
    when(mockUserRepository.login(any, any))
        .thenAnswer((_) async => Result<User>.success(testUser));
    // Act
    String email = 'test@test.com';
    String password = 'password';
    LoginParams params = LoginParams(email: email, password: password);
    var result = await loginUseCase.call(params);
    // Assert
    expect(result, Result<User>.success(testUser));
    verify(mockUserRepository.login(email, password));
    verifyNoMoreInteractions(mockUserRepository);
  });
}