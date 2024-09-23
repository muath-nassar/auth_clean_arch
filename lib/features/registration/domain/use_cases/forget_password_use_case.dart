import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/email_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

int _forgetPassWaitMin = 2;

class ForgetPasswordUseCase extends UseCase<String, EmailParams> {
  String? verificationCode;
  DateTime? sentTime;
  UserRepository repository;
  ForgetPasswordEmailService forgetPasswordEmailService;
  String? emailToVerify;

  ForgetPasswordUseCase({
    required this.repository,
    required this.forgetPasswordEmailService,
  });

  @override
  Future<Either<Failure, String>> call(EmailParams params) {
    return sendEmail(params);
  }

  Future<Either<Failure, String>> sendEmail(EmailParams params) async {
    if (sentTime != null &&
        DateTime.now().difference(sentTime!).inMinutes > _forgetPassWaitMin) {
      return const Left(EmailFailure([]));
    }
    var userCall = await repository.getUserByEmail(params.email);
    return userCall.fold((failure) => Left(failure), (user) async {
      verificationCode = generateRandomCode();
      var sendMailCall = await forgetPasswordEmailService(
          VerificationMailParams(
              receiverEmail: params.email, code: verificationCode!));
      return sendMailCall.fold((sendFailure) => Left(sendFailure), (code) {
        sentTime = DateTime.now();
        emailToVerify = params.email;
        return Right(code);
      });
    });
  }

  bool verifyInputCode(String inputCode) {
    return verifyCode(
        inputCode, verificationCode, sentTime, _forgetPassWaitMin);
  }

  Future<Either<Failure, String>> updatePassword(
      String inputCode, String newPassword){
    if (verifyInputCode(inputCode)) {
      return repository.changePassword(emailToVerify!, newPassword);
    }
    return Future.value(const Left(VerificationCodeFailure([]))) ;
  }
}
