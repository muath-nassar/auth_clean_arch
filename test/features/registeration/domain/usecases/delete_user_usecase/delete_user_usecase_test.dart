import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/delete_account_usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/forget_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_user_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])

main(){
  late MockUserRepository mockUserRepository;
  late DeleteAccountUsecase usecase;
  User testUser = User(
      id: 1,
      email: 'test@test.com',
      firstName: 'firstName',
      lastName: 'lastName');

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = DeleteAccountUsecase(mockUserRepository);
  });

  test('should delete user', () async {
    // Arrange
    when(mockUserRepository.deleteUser(any))
        .thenAnswer((_) async => Result<User>.success(testUser));
    // Act
    int id = 1;

    UserDeleteParams params = UserDeleteParams(id);
    var result = await usecase.call(params);
    // Assert
    expect(result, Result<User>.success(testUser));
    verify(mockUserRepository.deleteUser(id));
    verifyNoMoreInteractions(mockUserRepository);
  });
  
}