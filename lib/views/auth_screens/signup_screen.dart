import 'package:user/consts/consts.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  TextEditingController emailField = TextEditingController();
  TextEditingController nameField = TextEditingController();
  TextEditingController passField = TextEditingController();

  final form_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                "Create an account".text.fontFamily(semibold).size(22).make(),
                20.heightBox,
                customTextField(
                    name: "Name",
                    hint: "Enter your name",
                    controller: nameField),
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
                    onPressed: () async {
                      if (form_key.currentState!.validate()) {
                        controller
                            .userSignUp(context,
                                email: emailField.text, pass: passField.text)
                            .then(
                          (value) async {
                            await controller.storeAuthDetails(
                                name: nameField.text, email: emailField.text);
                            if (value != null) {
                              Get.offAll(() => UserRegistrationScreen());
                            }
                          },
                        );
                      }
                    },
                    child: controller.is_loading
                        ? const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : "Sign Up".text.fontFamily(semibold).size(16).make(),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
