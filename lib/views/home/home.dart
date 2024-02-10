import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:user/consts/colors.dart';
import 'package:user/controllers/auth_controller.dart';
import 'package:user/controllers/home_controller.dart';
import 'package:user/views/home/home_screen.dart';
import 'package:user/views/profile/profile_screen.dart';

class Home extends StatelessWidget {
  Home({super.key});

  List<Widget> Screens = [HomeScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      bottomNavigationBar:
          Consumer<HomeController>(builder: (context, controller, xxx) {
        return BottomNavigationBar(
          onTap: (value) {
            controller.updateScreen = value;
          },
          selectedItemColor: blueColor,
          currentIndex: controller.selectedScreenIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        );
      }),
      body: Consumer<HomeController>(builder: (context, controller, xxx) {
        return Screens[controller.selectedScreenIndex];
      }),
    );
  }
}
