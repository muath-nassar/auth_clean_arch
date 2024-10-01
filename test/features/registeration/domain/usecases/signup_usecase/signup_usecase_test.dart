import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/sign_up_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'signup_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])
main() {
  late MockUserRepository mockUserRepository;
  late SignUpUseCase signUpUseCase;
  User createdUser = User(id: 1,
      email: 'test@test.com',
      firstName: 'firstName',
      lastName: 'lastName');

  setUp(() {
    mockUserRepository = MockUserRepository();
    signUpUseCase = SignUpUseCase(mockUserRepository);
  });

  test('should get register the user s=using the repository', () async {
    // Arrange
    when(mockUserRepository.createUser(any, any, any, any))
        .thenAnswer((_) async => Result<User>.success(createdUser));
    // Act
    String email = 'test@test.com';
    String firstName = 'firstName';
    String lastName = 'lastName';
    String password = 'password';
    UserCreateParams params = UserCreateParams(email: email, firstName: firstName, lastName: lastName, password: password);
    var result = await signUpUseCase.call(params);
    // Assert
    expect(result, Result<User>.success(createdUser));
    verify(mockUserRepository.createUser(email, password, firstName, lastName));
    verifyNoMoreInteractions(mockUserRepository);
  });
}