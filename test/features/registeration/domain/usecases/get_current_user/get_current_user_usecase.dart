
import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/get_current_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_current_user_usecase.mocks.dart';

@GenerateMocks([UserRepository])
main() {
  late MockUserRepository mockUserRepository;
  late GetCurrentUserUsecase usecase;
  User testUser = User(id: 1,
      email: 'test@test.com',
      firstName: 'firstName',
      lastName: 'lastName');

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetCurrentUserUsecase(mockUserRepository);
  });

  test('should get the current user', () async {
    // Arrange
    when(mockUserRepository.getCurrentUser()).thenAnswer((_)async=>Result<User>.success(testUser));
    // Act

    var result = await usecase.call(NoParams());
    // Assert
    expect(result, Result<User>.success(testUser));
    verify(mockUserRepository.getCurrentUser());
    verifyNoMoreInteractions(mockUserRepository);
  });
}