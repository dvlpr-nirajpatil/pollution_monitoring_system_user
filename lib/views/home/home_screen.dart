import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/consts/colors.dart';
import 'package:user/consts/list.dart';
import 'package:user/consts/marginsAndPaddings.dart';
import 'package:user/consts/typography.dart';
import 'package:user/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await Provider.of<HomeController>(context, listen: false)
        .updatePaidStatus();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Errror");
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print("error");
  }

  void openCheckOut(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_aSIgdHeoVYMKRz',
      'amount': amount,
      'name': 'RSM POLYTECHNIC',
      'prefill': {
        'contact': '9665331199',
        'email': 'contact@rsmpoly.org',
      },
      'external': {
        'wallet': [
          'paytm',
        ]
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  getColor(value) {
    if (value > 100) {
      return Colors.red;
    } else if (value > 50) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: screenPadding,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.heightBox,
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Vehicles')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator()),
                  );
                }

                var documentData =
                    snapshot.data!.data() as Map<String, dynamic>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "${documentData['vehicle_number']}"
                            .text
                            .fontFamily(semibold)
                            .size(16)
                            .make(),
                        documentData['device_installed'] == true
                            ? "${documentData['ppm']}"
                                .text
                                .fontFamily(semibold)
                                .color(
                                    getColor(double.parse(documentData['ppm'])))
                                .make()
                            : "Device Not installed"
                                .text
                                .fontFamily(semibold)
                                .color(Colors.red)
                                .make()
                      ],
                    ),
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Model".text.make(),
                            "${documentData['vehicle_model']}"
                                .text
                                .fontFamily(semibold)
                                .make()
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "type".text.make(),
                            "${documentData['vehicle_type']}"
                                .text
                                .fontFamily(semibold)
                                .make()
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            "Insurance".text.make(),
                            "${documentData['insurance_status']}"
                                .text
                                .fontFamily(semibold)
                                .make()
                          ],
                        ),
                      ],
                    ),
                  ],
                )
                    .box
                    .roundedSM
                    .border(color: borderColor)
                    .padding(
                      const EdgeInsets.all(16),
                    )
                    .make();
              },
            ),
            20.heightBox,
            "Challans".text.fontFamily(semibold).size(18).make(),
            10.heightBox,
            Consumer<HomeController>(builder: (context, controller, xxx) {
              return Row(
                children: List.generate(
                  Challans.length,
                  (index) => "${Challans[index]}"
                      .text
                      .color(controller.selectedChallans == index
                          ? Colors.white
                          : blueColor)
                      .make()
                      .box
                      .border(color: blueColor)
                      .roundedSM
                      .color(controller.selectedChallans == index
                          ? blueColor
                          : Colors.white)
                      .padding(
                        EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      )
                      .margin(
                        EdgeInsets.only(right: 10),
                      )
                      .make()
                      .onTap(() {
                    controller.updateChallan = index;
                  }),
                ),
              );
            }),
            20.heightBox,
            Expanded(
              child:
                  Consumer<HomeController>(builder: (context, controller, xx) {
                return StreamBuilder<QuerySnapshot>(
                  stream: controller.selectedChallans == 0
                      ? FirebaseFirestore.instance
                          .collection('Challans')
                          .where('uid',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .where('paid_status', isEqualTo: 'pending')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('Challans')
                          .where('uid',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .where('paid_status', isEqualTo: 'paid')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: blueColor,
                          ),
                        ),
                      );
                    }

                    // Check if there are no pending documents
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text('No Challans found.'),
                      );
                    }

                    // Display the list of pending documents
                    return ListView.builder(
                      padding: EdgeInsets.all(0),
                      // itemCount: 10,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var document = snapshot.data!.docs[index];
                        // Access the document data using document.data()
                        var data = document.data() as Map<String, dynamic>;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "${data['vehicle_no']}"
                                    .text
                                    .fontFamily(semibold)
                                    .size(16)
                                    .make(),
                                "₹ ${data['fine']}"
                                    .text
                                    .color(data['paid_status'] == "paid"
                                        ? Colors.green
                                        : Colors.red)
                                    .fontFamily(semibold)
                                    .size(16)
                                    .make(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "PPM ".text.size(16).make(),
                                "${data['ppm']}".text.size(16).make(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Date ".text.size(16).make(),
                                "${data['date']}".text.size(16).make(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Due Date ".text.size(16).make(),
                                "${data['due_date']}".text.size(16).make(),
                              ],
                            ),
                            data['paid_status'] != "paid"
                                ? 20.heightBox
                                : SizedBox(),
                            data['paid_status'] != "paid"
                                ? FilledButton(
                                    onPressed: () {
                                      controller.SelectedChallanId =
                                          document.id;
                                      openCheckOut(int.parse(data['fine']));
                                    },
                                    child: "Pay Challan"
                                        .text
                                        .fontFamily(semibold)
                                        .size(14)
                                        .make())
                                : SizedBox()
                          ],
                        )
                            .box
                            .border(color: borderColor)
                            .padding(EdgeInsets.all(12))
                            .roundedSM
                            .margin(
                              EdgeInsets.only(
                                bottom: 20,
                              ),
                            )
                            .make();
                      },
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
