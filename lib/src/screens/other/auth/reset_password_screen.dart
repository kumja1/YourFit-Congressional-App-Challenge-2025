import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends GetWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Reset Password", style: TextStyle(fontSize: 30)),
        const SizedBox(height: 60.0),
        TextFormField()
      ],
    );
  }
}
