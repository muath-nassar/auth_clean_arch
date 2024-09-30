import 'package:auth_clean_arch/core/result/result.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/sign_out_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'signout_usecase.mocks.dart';

@GenerateMocks([UserRepository])
main() {
  late MockUserRepository mockUserRepository;
  late SignOutUseCase usecase;


  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = SignOutUseCase(mockUserRepository);
  });

  test('should get register the user s=using the repository', () async {
    // Arrange
    when(mockUserRepository.logout()).thenAnswer((_)async=>Result<void>.success((){}));
    // Act
    var result = await usecase.call(NoParams());
    // Assert
    expect(result.isSuccess(), true);
    verify(mockUserRepository.logout());
    verifyNoMoreInteractions(mockUserRepository);
  });
}