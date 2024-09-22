import 'package:auth_clean_arch/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../constants.dart';

abstract class EmailService<Type, Params> extends Equatable {
  final SmtpServer smtpServer;

  const EmailService(this.smtpServer);

  Future<Either<Failure, Type>> call(Params params);
}

class VerificationMailParams extends Equatable {
  final String receiverEmail;
  final String code;

  const VerificationMailParams(
      {required this.receiverEmail, required this.code});

  @override
  List<Object?> get props => [receiverEmail];
}

class VerificationEmailService
    extends EmailService<String, VerificationMailParams> {
  const VerificationEmailService(super.smtpServer);

  @override
  List<Object?> get props => [smtpServer];

  @override
  Future<Either<Failure, String>> call(VerificationMailParams params) async{
    var html = """
  <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
    <h3 style="color: #333; text-align: center;">Authorization Code</h3>
    <p style="font-size: 16px; color: #555; line-height: 1.5;">
      Dear user, <br><br>
      Please enter the following code to authorize your email and complete the verification process:
    </p>
    <div style="text-align: center; margin: 20px 0;">
      <span style="font-size: 24px; font-weight: bold; color: #2c3e50; background-color: #f9f9f9; padding: 10px 20px; border-radius: 5px; border: 1px solid #ddd;">${params.code}</span>
    </div>
    <p style="font-size: 14px; color: #777; text-align: center;">
      If you did not request this, please ignore this email.
    </p>
    <p style="font-size: 14px; color: #aaa; text-align: center;">
      Thank you!<br>
      Eng. Muath Nassar
    </p>
  </div>
""";
    var msg = Message();
    msg.subject = 'Verification Email';
    msg.from = const Address(Constants.appEmailAddress);
    msg.html = html;
    msg.recipients = [params.receiverEmail];

    try{
      await send(msg, smtpServer);
      return Right(params.code);
    }on MailerException catch(e){
      List<String> problemMessages =
      e.problems.map((problem) => problem.msg).toList();
      return Left(EmailFailure(problemMessages));
    }on Exception catch(e){
      return Left(EmailFailure([e.toString()]));
    }
  }
}


class ForgetPasswordEmailService
    extends EmailService<String, VerificationMailParams> {
  const ForgetPasswordEmailService(super.smtpServer);

  @override
  List<Object?> get props => [smtpServer];

  @override
  Future<Either<Failure, String>> call(VerificationMailParams params) async{
    var html = """
  <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
    <h3 style="color: #333; text-align: center;">Password Reset Request</h3>
    <p style="font-size: 16px; color: #555; line-height: 1.5;">
      Dear user, <br><br>
      We received a request to reset the password for your account. Please use the following code to reset your password:
    </p>
    <div style="text-align: center; margin: 20px 0;">
      <span style="font-size: 24px; font-weight: bold; color: #2c3e50; background-color: #f9f9f9; padding: 10px 20px; border-radius: 5px; border: 1px solid #ddd;">${params.code}</span>
    </div>
    <p style="font-size: 14px; color: #777; text-align: center;">
      If you did not request a password reset, please ignore this email or contact support if you have any concerns.
    </p>
    <p style="font-size: 14px; color: #aaa; text-align: center;">
      Thank you!<br>
      Eng. Muath Nassar
    </p>
  </div>
""";

    var msg = Message();
    msg.subject = 'Forget Password';
    msg.from = const Address(Constants.appEmailAddress);
    msg.html = html;
    msg.recipients = [params.receiverEmail];

    try{
      await send(msg, smtpServer);
      return Right(params.code);
    }on MailerException catch(e){
      List<String> problemMessages =
      e.problems.map((problem) => problem.msg).toList();
      return Left(EmailFailure(problemMessages));
    }on Exception catch(e){
      return Left(EmailFailure([e.toString()]));
    }
  }
}
