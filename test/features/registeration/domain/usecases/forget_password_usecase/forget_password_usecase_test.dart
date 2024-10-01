import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/forget_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])

main(){
  late MockUserRepository mockUserRepository;
  late ForgetPasswordUseCase usecase;
  // User testUser = User(
  //     id: 1,
  //     email: 'test@test.com',
  //     firstName: 'firstName',
  //     lastName: 'lastName');

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = ForgetPasswordUseCase(mockUserRepository);
  });

  test('should get change the password', () async {
    // Arrange
    when(mockUserRepository.changePassword(any, any))
        .thenAnswer((_) async => Result<bool>.success(true));
    // Act
    int id = 1;
    String password = 'password';

    ForgetPasswordParams params = ForgetPasswordParams(id: id, password: password);
    var result = await usecase.call(params);
    // Assert
    expect(result, Result<bool>.success(true));
    verify(mockUserRepository.changePassword(id, password));
    verifyNoMoreInteractions(mockUserRepository);
  });
}