import 'dart:io';

import 'package:auth_clean_arch/features/registration/domain/repositories/user_repository.dart';
import 'package:auth_clean_arch/features/registration/presentation/pages/home.dart';
import 'package:auth_clean_arch/features/registration/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'di.dart';
import 'features/registration/domain/entities/user.dart';

Future<void> main()  async{
  // Ensure that widget binding is initialized
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await initDi();

  runApp(MyApp(home: await _getHome(),));
}

class MyApp extends StatelessWidget {
  final Widget home;
  const MyApp({super.key, required this.home});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}


Future<User?> _checkLoginIn()async{
  var getCurrent = await getIt<UserRepository>().getCurrentUser();
  if(getCurrent.isSuccess()){
    return getCurrent.data!;
  }
  return null;
}

Future<Widget> _getHome()async{
  User? loggedUser = await _checkLoginIn();
  if(loggedUser == null){
    return const  SignInPage();
  }
  debugPrint('loggedUser $loggedUser | ${loggedUser.email}');
  return HomePage(user: loggedUser);
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
