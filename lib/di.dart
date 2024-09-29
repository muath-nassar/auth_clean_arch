// import 'dart:async';
//
// import 'package:auth_clean_arch/core/database/database.dart';
// import 'package:auth_clean_arch/core/services/email_service.dart';
// import 'package:auth_clean_arch/core/utils/encryption.dart';
// import 'package:auth_clean_arch/core/utils/validators/email_validator.dart';
// import 'package:auth_clean_arch/core/utils/validators/password_validator.dart';
// import 'package:auth_clean_arch/features/registration/data/datasources/remote_user_datasource.dart';
// import 'package:auth_clean_arch/features/registration/data/datasources/local_user_datasource.dart';
// import 'package:auth_clean_arch/features/registration/data/repositories/user_repository.dart';
// import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
// import 'package:auth_clean_arch/features/registration/domain/use_cases/delete_account_usecase.dart';
// import 'package:auth_clean_arch/features/registration/domain/use_cases/forget_password_use_case.dart';
// import 'package:auth_clean_arch/features/registration/domain/use_cases/login_use_case.dart';
// import 'package:auth_clean_arch/features/registration/domain/use_cases/sign_up_use_case.dart';
// import 'package:auth_clean_arch/features/registration/domain/use_cases/verify_email_use_case.dart';
// import 'package:auth_clean_arch/features/registration/presentation/bloc/change_password_bloc/change_password_bloc.dart';
// import 'package:auth_clean_arch/features/registration/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
// import 'package:auth_clean_arch/features/registration/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';
// import 'package:auth_clean_arch/features/registration/presentation/bloc/verify_email_bloc/verify_email_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'core/constants.dart';
// import 'features/registration/domain/use_cases/sign_out_use_case.dart';
//
// final getIt = GetIt.instance;
//
// Future<void> initDi() async{
//   // Features
//   initBlocs();
//   initUseCases();
//   initRepositories();
//   initDatasources();
//   // Core
//   initValidators();
//   initServices();
//   initUtil();
//   initDb();
//   // External
//   await initExternal();
// }
//
// void initDatasources() {
//   getIt.registerLazySingleton<UserModelLocalDbDatasource>(
//       () => UserModelLocalDbDatasourceImpl(db: getIt()));
//   getIt.registerLazySingleton<LocalSharedPrefDatasource>(
//       () => LocalSharedPrefDatasourceImpl(getIt()));
// }
//
// void initRepositories() {
//   getIt.registerLazySingleton<UserRepository>(
//       () => UserRepositoryImp(dbDatasource: getIt(), prefDatasource: getIt()));
// }
//
// void initUtil() {
//   getIt.registerLazySingleton(() => PasswordHashingUtil());
// }
//
// void initUseCases() {
//   // sign in, sign out, sign up, delete, send auth email, change password
//   getIt.registerLazySingleton(
//       () => LoginUseCase(repository: getIt(), hashUtil: getIt()));
//   getIt.registerLazySingleton(() => SignUpUseCase(getIt(), getIt()));
//   getIt.registerLazySingleton(() => SignOutUseCase(getIt()));
//   getIt.registerLazySingleton(() => DeleteAccountUsecase(getIt()));
//   getIt.registerLazySingleton(() => ForgetPasswordUseCase(
//       repository: getIt(), forgetPasswordEmailService: getIt(), hashingUtil: getIt()));
//   getIt.registerLazySingleton(() => VerifyEmailUseCase(
//       repository: getIt(), verificationEmailService: getIt()));
// }
//
// Future<void> initExternal() async {
//   getIt.registerLazySingleton<SmtpServer>(
//       () => hotmail(Constants.appEmailAddress, Constants.appEmailPassword));
//   final sharedPreferences = await SharedPreferences.getInstance();
//   getIt.registerLazySingleton(() => sharedPreferences);
// }
//
// void initDb() {
//   getIt.registerLazySingleton(() => AppDatabase());
// }
//
// void initServices() {
//   getIt.registerLazySingleton(() => VerificationEmailService(getIt()));
//   getIt.registerLazySingleton(() => ForgetPasswordEmailService(getIt()));
// }
//
// void initValidators() {
//   getIt.registerLazySingleton(() => EmailValidator());
//   getIt.registerLazySingleton(() => PasswordValidator());
// }
//
// void initBlocs() {
//   getIt.registerFactory(() => SignUpBloc(
//       emailValidator: getIt(),
//       passwordValidator: getIt(),
//       signUpUserCase: getIt()));
//   getIt.registerFactory(() => SignInBloc(
//       emailValidator: getIt(),
//       passwordValidator: getIt(),
//       loginUseCase: getIt()));
//   getIt.registerFactory(() =>
//       VerifyEmailBloc(emailValidator: getIt(), verifyEmailUseCase: getIt()));
//   getIt.registerFactory(() => ChangePasswordBloc(
//       emailValidator: getIt(), passwordValidator: getIt(), useCase: getIt()));
// }
