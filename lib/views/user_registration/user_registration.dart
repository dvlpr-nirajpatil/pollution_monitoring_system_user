import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';
import 'package:user/consts/list.dart';
import 'package:user/consts/marginsAndPaddings.dart';
import 'package:user/consts/typography.dart';
import 'package:user/controllers/userRegistrationController.dart';
import 'package:user/views/home/home.dart';
import 'package:user/views/shared_widgets/customFormField.dart';
import 'package:user/views/shared_widgets/customTextField.dart';
import 'package:velocity_x/velocity_x.dart';

class UserRegistrationScreen extends StatelessWidget {
  UserRegistrationScreen({super.key});

  final form_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var controller =
        Provider.of<UserRegistrationController>(context, listen: false);
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: screenPadding,
        child: SingleChildScrollView(
          child: Form(
            key: form_key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.height * 0.04,
                ),
                "Add your vehicle".text.fontFamily(semibold).size(22).make(),
                20.heightBox,
                customTextField(
                  name: "Vehicle Number",
                  hint: "MH 15 GB 90008",
                  controller: controller.vehicleDetails.vehicleNumber,
                ),
                customDropDownButton(
                    hint: "Select Vehicle Type",
                    onchange: (value) {
                      controller.vehicleDetails.selectedVehicleType = value;
                    },
                    label: "Select Vehicle Type",
                    list: VehicleTypes,
                    selectedValue:
                        controller.vehicleDetails.selectedVehicleType),
                customDropDownButton(
                    hint: "Select your insurance status",
                    onchange: (value) {
                      controller.vehicleDetails.insurance_status = value;
                    },
                    label: "Select Insurance status",
                    list: insuranceStatus,
                    selectedValue: controller.vehicleDetails.insurance_status),
                customTextField(
                  name: "Vehicle Color",
                  hint: "black/ red",
                  controller: controller.vehicleDetails.vehicleColor,
                ),
                customTextField(
                  name: "Vehicle Brand",
                  hint: "mahindra/ mercedes",
                  controller: controller.vehicleDetails.vehicleBrand,
                ),
                customTextField(
                  name: "Vehicle Model",
                  hint: "XUV 500",
                  controller: controller.vehicleDetails.vehicleModel,
                ),
                customDropDownButton(
                    hint: "Select Device Status",
                    onchange: (value) {
                      controller.vehicleDetails.deviceStatus = value;
                    },
                    label: "Have you Installed the Device ?",
                    list: DeviceStatus,
                    selectedValue: controller.vehicleDetails.deviceStatus),
                30.heightBox,
                FilledButton(
                    onPressed: () async {
                      if (form_key.currentState!.validate()) {
                        await controller.storeVehicles();
                        Get.off(() => Home());
                      }
                    },
                    child: "Continue".text.make()),
                30.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
