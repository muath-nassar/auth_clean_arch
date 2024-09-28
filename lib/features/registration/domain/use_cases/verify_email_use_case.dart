import 'dart:async';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/email_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

int _verifyWaitingInMin = 5;
class VerifyEmailUseCase extends UseCase<String, EmailParams> {
  String? verificationCode;
  DateTime? sentTime;
  UserRepository repository;
  VerificationEmailService verificationEmailService;
  String? emailToVerify;

  VerifyEmailUseCase({
    required this.repository,
    required this.verificationEmailService,
  });

  @override
  Future<Either<Failure, String>> call(EmailParams params) {
    return sendEmail(params);
  }

  Duration? _getRemainingTimeToFinish(){
    var endIn = sentTime?.add(const Duration(minutes: 5));
    return endIn?.difference(DateTime.now());
  }

  String _getTimerErrorMSg(){
    var duration = _getRemainingTimeToFinish();
    int minutes = duration!.inMinutes;
    int seconds = duration.inSeconds.remainder(60);

    if (minutes > 0) {
      return "Remaining time $minutes minutes and $seconds seconds";
    } else {
      return "Remaining time $seconds seconds";
    }
  }

  Future<Either<Failure, String>> sendEmail(EmailParams params) async {
    if (sentTime != null &&
        DateTime.now().difference(sentTime!).inMinutes < _verifyWaitingInMin) {
      return Left(EmailFailure([_getTimerErrorMSg()]));
    }
    // try{
      var userCall = await repository.getUserByEmail(params.email);
      return userCall.fold((failure) => Left(failure), (user) async {
        verificationCode = generateRandomCode();
        var sendMailCall = await verificationEmailService(VerificationMailParams(
            receiverEmail: params.email, code: verificationCode!));
        return sendMailCall.fold((sendFailure) {
          print('********');
          return Left(sendFailure);
        }, (code) {
          sentTime = DateTime.now();
          emailToVerify = params.email;
          return Right(code);
        });
      });
    // }catch(e){
    //   return const Left(EmailFailure(['Something is wrong while sending the email']));
    // }

  }

  bool verifyInputCode(String inputCode) {
    return verifyCode(inputCode,verificationCode,sentTime,_verifyWaitingInMin);
  }

  Future<Either<Failure, User>> verifyEmail(String inputCode) async {
    if (verifyInputCode(inputCode)) {
      var getTheEmailUserCall =
          await repository.getUserByEmail(emailToVerify!);
      return getTheEmailUserCall.fold(
              (getFailure) => Left(getFailure),
              (user)=>  repository.updateUser(updateVerifiedEmailField(user))
      );
    }
    return const Left(VerificationCodeFailure([]));
  }

  User updateVerifiedEmailField(User user) {
    return User(
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        createTime: user.createTime,
        lastLogin: user.createTime,
        emailVerified: true);
  }
}
