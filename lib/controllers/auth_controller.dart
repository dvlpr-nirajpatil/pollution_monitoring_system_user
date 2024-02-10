import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user/consts/consts.dart';
import 'package:user/consts/email_format.dart';
import 'package:user/views/shared_widgets/customSnackBar.dart';

class AuthController extends ChangeNotifier {
  bool is_loading = false;

  set loading(value) {
    is_loading = value;
    notifyListeners();
  }

  Future<UserCredential?> userSignIn({email, pass}) async {
    loading = true;
    UserCredential? user;
    try {
      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }

    loading = false;
    return user;
  }

  Future<UserCredential?> userSignUp(context, {email, pass}) async {
    UserCredential? user;

    loading = true;

    try {
      user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        showSnackbar(context,
            "Incorrect login credentials. Please check and try again.");
      } else if (e.code == "invalid-credential") {
        showSnackbar(context, "Email address does not exist.");
      } else if (e.code == "invalid-email") {
        showSnackbar(context, "Invalid email address.");
      } else if (e.code == "channel-error") {
        showSnackbar(context, "Something went wrong check your credentials.");
      } else {
        showSnackbar(context, "Something went wrong .");
      }
    }
    loading = false;
    return user;
  }

  Future<void> userSignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  storeAuthDetails({name, email}) async {
    await FirebaseFirestore.instance
        .collection('Vehicles')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "username": name,
        "login_email": email,
      },
    );

    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
  }

  Future<void> NavigateUser() async {
    try {
      // Get reference to Firestore collection
      CollectionReference vehiclesCollection =
          FirebaseFirestore.instance.collection('Vehicles');

      // Get document snapshot based on UID
      DocumentSnapshot documentSnapshot = await vehiclesCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Check if document exists
      if (documentSnapshot.exists) {
        // Return the entire document as a Map
        var data = documentSnapshot.data() as Map<String, dynamic>;

        if (data['vehicle_added'] == true) {
          Get.offAll(() => Home());
        } else {
          Get.off(() => UserRegistrationScreen());
        }
      } else {
        // Return an empty Map if document does not exist
      }
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching document: $e');
      throw e; // Re-throw the error to handle it in the calling code
    }
  }
}
