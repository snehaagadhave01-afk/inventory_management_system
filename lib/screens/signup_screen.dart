import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } on Exception catch (e) {
      if (!mounted) return;

      String message = 'Unable to create account.';

      final error = e.toString();

      if (error.contains('email-already-in-use')) {
        message = 'This email is already registered.';
      } else if (error.contains('weak-password')) {
        message = 'Password is too weak.';
      } else if (error.contains('invalid-email')) {
        message = 'Please enter a valid email.';
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Create Account',
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
              children: [
                const SizedBox(height: 10),

                const CircleAvatar(
                  radius: 45,
                  backgroundColor:
                      Color(0xff2962FF),
                  child: Icon(
                    Icons.person_add_outlined,
                    color: Colors.white,
                    size: 45,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Sign up to manage your inventory',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  controller: nameController,
                  hintText: 'Full Name',
                  prefixIcon:
                      Icons.person_outline,
                  textInputAction:
                      TextInputAction.next,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  prefixIcon:
                      Icons.email_outlined,
                  keyboardType:
                      TextInputType.emailAddress,
                  textInputAction:
                      TextInputAction.next,
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

                const SizedBox(height: 18),

                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIcon:
                      Icons.lock_outline,
                  obscureText: hidePassword,
                  textInputAction:
                      TextInputAction.next,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword =
                            !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_outlined
                          : Icons
                              .visibility_off_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please enter password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller:
                      confirmPasswordController,
                  hintText: 'Confirm Password',
                  prefixIcon:
                      Icons.lock_reset_outlined,
                  obscureText:
                      hideConfirmPassword,
                  textInputAction:
                      TextInputAction.done,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hideConfirmPassword =
                            !hideConfirmPassword;
                      });
                    },
                    icon: Icon(
                      hideConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons
                              .visibility_off_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value !=
                        passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: 'Create Account',
                  icon: Icons.person_add_outlined,
                  isLoading: isLoading,
                  onPressed: signup,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LoginScreen(),
                                ),
                              );
                            },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}