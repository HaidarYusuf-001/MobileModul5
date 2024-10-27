import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codingaja/app/modules/home/views/home_view.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key for validation

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
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Wrap with Form widget
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) { // Add email validation
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.isEmail) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) { // Add password validation
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GetX<AuthController>(
                builder: (controller) {
                  return ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) { // Validate form
                        controller.loginUser(
                          _emailController.text,
                          _passwordController.text,
                        ).then((_) {
                          // Navigate to HomeView after successful login
                          if (controller.isLoading.isFalse) {
                            Get.offAll(HomeView());
                          }
                        });
                      }
                    },
                    child: controller.isLoading.value
                        ? CircularProgressIndicator()
                        : Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}