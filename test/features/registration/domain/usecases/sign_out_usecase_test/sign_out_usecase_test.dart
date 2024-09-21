import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:auth_clean_arch/core/usecases/usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/sign_out_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../sign_up_usecase/sign_up_usecase_test.mocks.dart';

main(){
  late SignOutUseCase useCase;
  late MockUserRepository mockUserRepository;
setUp((){
  mockUserRepository = MockUserRepository();
  useCase = SignOutUseCase(mockUserRepository);
});
  test('should return 0 as the current user id', () async {
    // Arrange
    when(mockUserRepository.cacheCurrentUser(any))
        .thenAnswer((_)async=>const Right(0));
    // Act
    var result = await useCase(NoParams());
    // Assert
    expect(result, const Right(0));
  });

  test('should return CacheFailure if caching fails', () async {
    // Arrange
    when(mockUserRepository.cacheCurrentUser(any))
        .thenAnswer((_)async=>const Left(CacheFailure([])));
    // Act
    var result = await useCase(NoParams());
    // Assert
    expect(result, const Left(CacheFailure([])));
  });
}