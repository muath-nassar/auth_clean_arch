import 'dart:async';
import 'dart:io';

import 'package:auth_clean_arch/core/network/network.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/local_user_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/datasources/remote_user_datasource.dart';
import 'package:auth_clean_arch/features/registration/data/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/get_current_user_usecase.dart';
import 'package:auth_clean_arch/features/registration/domain/use_cases/get_user_using_email_usecase.dart';
import 'package:auth_clean_arch/features/registration/presentation/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:auth_clean_arch/features/registration/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';

import 'core/utils/validators/email_validator.dart';
import 'core/utils/validators/password_validator.dart';
import 'features/registration/data/models/user_model.dart';
import 'features/registration/domain/repositories/user_repository.dart';
import 'features/registration/domain/use_cases/delete_account_usecase.dart';
import 'features/registration/domain/use_cases/forget_password_use_case.dart';
import 'features/registration/domain/use_cases/login_use_case.dart';
import 'features/registration/domain/use_cases/sign_out_use_case.dart';
import 'features/registration/domain/use_cases/sign_up_use_case.dart';
import 'features/registration/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'features/registration/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';


final getIt = GetIt.instance;

Future<void> initDi()  async{
  // Features
  initBlocs();
  initUseCases();
  initRepositories();
  initDatasources();
  initUtil();
  // Core
  initValidators();
  // External
  initExternal();
  await initHive();
}

void initUtil(){
  getIt.registerLazySingleton<NetworkInfo>(()=>NetworkInfoImp(getIt()));
}

void initDatasources() {
  getIt.registerLazySingleton<LocalUserDatasource>(
      () => LocalUserDatasourceImpl(getIt()));
  getIt.registerLazySingleton<RemoteUserDataSource>(
      () => RemoteUserDatasourceImp(httpClient: getIt(), networkInfo: getIt()));
}

void initRepositories() {
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImp(
      remoteUserDataSource: getIt(), localUserDatasource: getIt()));
}

void initUseCases() {
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAccountUsecase(getIt()));
  getIt.registerLazySingleton(() => ForgetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUsecase(getIt()));
  getIt.registerLazySingleton(() => GetUserUsingEmailUsecase(getIt()));

}

void initExternal() async {
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(()=>InternetConnectionChecker());
}

void initValidators() {
  getIt.registerLazySingleton(() => EmailValidator());
  getIt.registerLazySingleton(() => PasswordValidator());
}

void initBlocs() {
  getIt.registerFactory(() => SignUpBloc(
      emailValidator: getIt(),
      passwordValidator: getIt(),
      signUpUserCase: getIt()));
  getIt.registerFactory(() => SignInBloc(
      emailValidator: getIt(),
      passwordValidator: getIt(),
      loginUseCase: getIt()));
  getIt.registerFactory(() => ChangePasswordBloc(
      emailValidator: getIt(),
      passwordValidator: getIt(),
      forgetPasswordUseCase: getIt(),
      getUserUsingEmailUsecase: getIt()));
  getIt.registerFactory(() => HomeBloc(getIt(), getIt()));
}

Future<void> initHive() async {
  // Get the correct application documents directory for mobile and desktop
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;

  // Initialize Hive with the obtained path
  await Hive.initFlutter(path); // `Hive.initFlutter` is specific for Flutter

  // Register the adapter for UserModel
  Hive.registerAdapter(UserModelAdapter());

  // Open the user box
  Box<UserModel> userBox = await Hive.openBox<UserModel>('userBox');

  // Register the userBox as a singleton in get_it
  getIt.registerSingleton<Box<UserModel>>(userBox);
}
