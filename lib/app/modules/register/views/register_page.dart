import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      TextField(
        controller: _emailController,
        decoration: InputDecoration(labelText: 'Email'),
      ),
      TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(labelText: 'Password'),
      ),
      SizedBox(height: 16),
      Obx(() {
        return ElevatedButton(
          onPressed: _authController.isLoading.value
              ? null
              : () {
            _authController.registerUser(
              _emailController.text,
              _passwordController.text,
            );
          },
          child: _authController.isLoading.value
              ? CircularProgressIndicator()
              : Text('Register'),
        );
      }),
    ],
    ),
        ),
    );
  }
}