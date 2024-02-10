import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  int selectedScreenIndex = 0;

  String SelectedChallanId = "";

  int selectedChallans = 0;

  set updateChallan(int value) {
    selectedChallans = value;
    notifyListeners();
  }

  set updateScreen(int value) {
    selectedScreenIndex = value;
    notifyListeners();
  }

  Future<void> updateChallanStatus() async {
    // Access the Firestore collection

    String userId = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference vehiclesCollection =
        FirebaseFirestore.instance.collection('Vehicles');

    try {
      // Update the document where user_id matches

      await vehiclesCollection.doc(userId).update({
        'ppm': "40",
        'challan': false,
      });

      print('Challan status updated to false for user ID $userId');
    } catch (e) {
      print('Error updating challan status: $e');
    }
  }

  Future<void> updatePaidStatus() async {
    try {
      // Reference to the Firestore collection
      CollectionReference collection = FirebaseFirestore.instance.collection(
          'Challans'); // Replace 'challan' with your collection name

      // Retrieve the document by its ID
      DocumentSnapshot documentSnapshot =
          await collection.doc(SelectedChallanId).get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Update the document with the new paid_status value
        await collection.doc(SelectedChallanId).update({'paid_status': 'paid'});
      }
      await updateChallanStatus();
    } catch (e) {
      print("Error updating paid status: $e");
    }
  }
}
