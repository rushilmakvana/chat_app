import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorText;
  const ErrorScreen({required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          errorText,
        ),
      ),
    );
  }
}
