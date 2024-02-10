import 'package:user/consts/consts.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  TextEditingController emailField = TextEditingController();
  TextEditingController nameField = TextEditingController();
  TextEditingController passField = TextEditingController();

  final form_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<AuthController>(context, listen: false);
    return Scaffold(
      body: Container(
        padding: screenPadding,
        width: context.width,
        child: SingleChildScrollView(
          child: Form(
            key: form_key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.height * 0.13,
                ),
                "Hello Again!".text.fontFamily(semibold).size(22).make(),
                20.heightBox,
                customTextField(
                    name: "Email",
                    hint: "Enter your email",
                    controller: emailField),
                customTextField(
                    name: "Password",
                    hint: "Enter Password",
                    is_pass: true,
                    controller: passField),
                20.heightBox,
                Consumer<AuthController>(builder: (context, controller, xxx) {
                  return FilledButton(
                    onPressed: () {
                      if (form_key.currentState!.validate()) {
                        controller
                            .userSignIn(
                                email: emailField.text, pass: passField.text)
                            .then((value) {
                          if (value != null) {
                            Get.off(() => Home());
                          }
                        });
                      }
                    },
                    child: controller.is_loading
                        ? SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : "Sign In".text.make(),
                  );
                }),
                20.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    "Dont have an account?".text.make(),
                    10.widthBox,
                    "Sign Up".text.fontFamily(semibold).color(blueColor).make(),
                  ],
                ).onTap(() {
                  Get.to(() => SignUpScreen());
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
