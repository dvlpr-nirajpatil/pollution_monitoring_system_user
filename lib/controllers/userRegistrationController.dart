import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user/consts/email_format.dart';
import 'package:user/models/vehicle_details_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRegistrationController extends ChangeNotifier {
  VehicleDetails vehicleDetails = VehicleDetails();
  bool is_loading = false;

  set loading(value) {
    is_loading = value;
    notifyListeners();
  }

  Future<void> storeVehicles() async {
    loading = true;
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Vehicles")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;

        userData['vehicle_number'] = vehicleDetails.vehicleNumber.text;
        userData['vehicle_type'] = vehicleDetails.selectedVehicleType;
        userData['vehicle_color'] = vehicleDetails.vehicleColor.text;
        userData['vehicle_brand'] = vehicleDetails.vehicleBrand.text;
        userData['vehicle_model'] = vehicleDetails.vehicleModel.text;
        userData['insurance_status'] = vehicleDetails.insurance_status;
        userData['ppm'] = "0";
        userData['device_installed'] =
            vehicleDetails.deviceStatus == "Installed" ? true : false;
        userData['challan'] = false;
        userData['vehicle_added'] = true;

        await FirebaseFirestore.instance
            .collection('Vehicles')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(userData);

        if (vehicleDetails.deviceStatus != "Installed") {
          sendEmail(
            to: FirebaseAuth.instance.currentUser!.email,
          );
        }
      }
    } catch (e) {
      print(e);
    }
    loading = false;
  }

  Future<void> sendEmail({to, name}) async {
    try {
      final Uri url = Uri.parse('http://3.147.78.78:80/send-email');

      final Map<String, dynamic> requestBody = {
        'to': to,
        'text': getInstallationWarning(),
        'subject':
            "Urgent: Installation of Vehicle Pollution Monitoring Device Required",
      };

      final http.Response response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Email sent successfully.');
      } else {
        print('Error sending email. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error sending email: $error');
    }
  }
}
