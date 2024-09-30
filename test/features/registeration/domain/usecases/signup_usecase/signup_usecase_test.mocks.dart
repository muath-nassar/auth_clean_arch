// Mocks generated by Mockito 5.4.4 from annotations
// in auth_clean_arch/test/features/registeration/domain/usecases/signup_usecase/signup_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:auth_clean_arch/core/result/result.dart' as _i2;
import 'package:auth_clean_arch/features/registration/domain/entities/user.dart'
    as _i5;
import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeResult_0<T> extends _i1.SmartFake implements _i2.Result<T> {
  _FakeResult_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i3.UserRepository {
  MockUserRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Result<_i5.User>> getUser(int? userId) => (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [userId],
        ),
        returnValue:
            _i4.Future<_i2.Result<_i5.User>>.value(_FakeResult_0<_i5.User>(
          this,
          Invocation.method(
            #getUser,
            [userId],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.User>>);

  @override
  _i4.Future<_i2.Result<_i5.User>> getCurrentUser() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentUser,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Result<_i5.User>>.value(_FakeResult_0<_i5.User>(
          this,
          Invocation.method(
            #getCurrentUser,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.User>>);

  @override
  _i4.Future<_i2.Result<_i5.User>> createUser(
    String? email,
    String? password,
    String? firstName,
    String? lastName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createUser,
          [
            email,
            password,
            firstName,
            lastName,
          ],
        ),
        returnValue:
            _i4.Future<_i2.Result<_i5.User>>.value(_FakeResult_0<_i5.User>(
          this,
          Invocation.method(
            #createUser,
            [
              email,
              password,
              firstName,
              lastName,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.User>>);

  @override
  _i4.Future<_i2.Result<_i5.User>> login(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [
            email,
            password,
          ],
        ),
        returnValue:
            _i4.Future<_i2.Result<_i5.User>>.value(_FakeResult_0<_i5.User>(
          this,
          Invocation.method(
            #login,
            [
              email,
              password,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.User>>);

  @override
  _i4.Future<_i2.Result<void>> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #logout,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);

  @override
  _i4.Future<_i2.Result<bool>> changePassword(
    int? userId,
    String? newPassword,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #changePassword,
          [
            userId,
            newPassword,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<bool>>.value(_FakeResult_0<bool>(
          this,
          Invocation.method(
            #changePassword,
            [
              userId,
              newPassword,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<bool>>);

  @override
  _i4.Future<_i2.Result<_i5.User>> updateUser(
    int? userId,
    _i5.User? updatedUser,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUser,
          [
            userId,
            updatedUser,
          ],
        ),
        returnValue:
            _i4.Future<_i2.Result<_i5.User>>.value(_FakeResult_0<_i5.User>(
          this,
          Invocation.method(
            #updateUser,
            [
              userId,
              updatedUser,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.User>>);

  @override
  _i4.Future<_i2.Result<_i5.User>> deleteUser(int? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteUser,
          [userId],
        ),
        returnValue:
            _i4.Future<_i2.Result<_i5.User>>.value(_FakeResult_0<_i5.User>(
          this,
          Invocation.method(
            #deleteUser,
            [userId],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.User>>);
}
