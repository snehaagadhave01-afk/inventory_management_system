import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController emailController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseService.resetPassword(
        emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset link sent to your email.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch (e) {
      if (!mounted) return;

      String message =
          'Unable to send reset link.';

      final error = e.toString();

      if (error.contains('user-not-found')) {
        message = 'No account found with this email.';
      } else if (error.contains('invalid-email')) {
        message = 'Please enter a valid email address.';
      } else if (error.contains('too-many-requests')) {
        message =
            'Too many requests. Please try again later.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),

                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Color(0xff2962FF),
                    child: Icon(
                      Icons.lock_reset,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Center(
                  child: Text(
                    'Reset Your Password',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    'Enter your registered email address and we will send you a password reset link.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  prefixIcon:
                      Icons.email_outlined,
                  keyboardType:
                      TextInputType.emailAddress,
                  textInputAction:
                      TextInputAction.done,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!RegExp(
                      r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                    ).hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: 'Send Reset Link',
                  icon: Icons.email_outlined,
                  isLoading: isLoading,
                  onPressed: sendResetLink,
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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