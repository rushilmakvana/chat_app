import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            // height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Welcome to whatsapp',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: size.height / 9,
                ),
                Image.asset(
                  'assets/bg.png',
                  height: 340,
                  width: 340,
                  color: tabColor,
                ),
                SizedBox(
                  height: size.height / 9,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Read our privacy policy. Tap "Agree and continue" to accept the terms of service.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: greyColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: size.width * 0.75,
                  child: CustomButton(
                    text: 'AGREE AND CONTINUE',
                    onPressed: () => navigateToLoginScreen(
                      context,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
