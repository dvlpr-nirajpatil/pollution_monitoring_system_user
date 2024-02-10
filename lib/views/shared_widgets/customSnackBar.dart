import 'package:user/consts/consts.dart';

void showSnackbar(BuildContext context, text) {
  final snackBar = SnackBar(
    backgroundColor: blueColor,
    content: Text(text),
    duration: const Duration(seconds: 3), // You can customize the duration
  );

  // Show the Snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
