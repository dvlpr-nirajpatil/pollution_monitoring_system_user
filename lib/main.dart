import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:user/consts/colors.dart';
import 'package:user/consts/typography.dart';
import 'package:user/controllers/auth_controller.dart';
import 'package:user/controllers/home_controller.dart';
import 'package:user/controllers/userRegistrationController.dart';
import 'package:user/firebase_options.dart';
import 'package:user/views/auth_screens/sign_in_screen.dart';
import 'package:user/views/auth_screens/splash_screen.dart';
import 'package:user/views/user_registration/user_registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UserRegistrationController()),
        ChangeNotifierProvider(create: (_) => HomeController())
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: regular,
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: blueColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
