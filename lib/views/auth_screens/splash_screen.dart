import 'package:firebase_auth/firebase_auth.dart';
import 'package:user/consts/consts.dart';
import 'package:user/consts/images.dart';
import 'package:user/views/auth_screens/sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // ignore: non_constant_identifier_names
  ChangeScreen(context) {
    Future.delayed(const Duration(seconds: 1), () {
      FirebaseAuth.instance.authStateChanges().listen((value) async {
        if (value != null) {
          await Provider.of<AuthController>(context, listen: false)
              .NavigateUser();
        } else {
          Get.offAll(() => SignInScreen(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 500));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ChangeScreen(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iglogo,
              width: width * 0.5,
            ),
            20.heightBox,
            "RSM Polytechnic".text.size(16).fontFamily(semibold).make()
          ],
        ),
      ),
    );
  }
}
