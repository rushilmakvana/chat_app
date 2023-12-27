import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class CustomButton extends StatelessWidget {
  String text;
  VoidCallback onPressed;
  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: tabColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
