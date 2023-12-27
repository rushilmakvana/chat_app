import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  Country? country;
  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country _country) {
        setState(
          () {
            country = _country;
          },
        );
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNum = _phoneController.text.trim();
    if (country != null && phoneNum.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signinWithPhone(context, '+${country!.phoneCode}${phoneNum}');
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Enter your phone number',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(
            18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Whatsapp will need to varify your phone number',
                // textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: pickCountry,
                child: const Text(
                  'Pick country',
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  if (country != null)
                    Text(
                      country!.flagEmoji,
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.6,
              ),
              SizedBox(
                width: 90,
                child: CustomButton(
                  text: 'NEXT',
                  onPressed: sendPhoneNumber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
