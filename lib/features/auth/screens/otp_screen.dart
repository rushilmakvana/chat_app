import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class OtpScreen extends ConsumerWidget {
  static const routeName = '/opt-screen';
  final String verificationId;
  const OtpScreen({required this.verificationId});

  void verifyOtp(WidgetRef ref, BuildContext context, String userOtp) {
    ref
        .read(authControllerProvider)
        .verifyOtp(context, verificationId, userOtp);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          title: const Text(
            'Verifying your number',
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'We have sent an SMS with a code',
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * 0.5,
                child: TextField(
                  onChanged: (val) {
                    if (val.trim().length == 6) {
                      verifyOtp(ref, context, val);
                    }
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: '-  -  -  -  -  -',
                    hintStyle: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
