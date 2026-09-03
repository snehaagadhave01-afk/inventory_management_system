import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'dashboard_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isLoggingIn = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoggingIn = true;
    });

    // Currently using local/demo login.
    // Firebase authentication can be connected later.

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      isLoggingIn = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              children: [
                const SizedBox(height: 60),

                // APP ICON
                const CircleAvatar(
                  radius: 50,
                  backgroundColor:
                      Color(0xff2962FF),

                  child: Icon(
                    Icons.inventory_2,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 25),

                // TITLE
                const Text(
                  'Inventory Management',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // SUBTITLE
                const Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                // EMAIL
                CustomTextField(
                  controller:
                      emailController,

                  hintText:
                      'Email Address',

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
                    ).hasMatch(
                      value.trim(),
                    )) {
                      return 'Enter a valid email address';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PASSWORD
                CustomTextField(
                  controller:
                      passwordController,

                  hintText: 'Password',

                  prefixIcon:
                      Icons.lock_outline,

                  obscureText:
                      !isPasswordVisible,

                  textInputAction:
                      TextInputAction.done,

                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible =
                            !isPasswordVisible;
                      });
                    },

                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please enter your password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 8),

                // FORGOT PASSWORD
                Align(
                  alignment:
                      Alignment.centerRight,

                  child: TextButton(
                    onPressed:
                        isLoggingIn
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },

                    child: const Text(
                      'Forgot Password?',
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // LOGIN BUTTON
                CustomButton(
                  text: 'Login',

                  icon: Icons.login,

                  isLoading: isLoggingIn,

                  onPressed: login,
                ),

                const SizedBox(height: 30),

                // DIVIDER
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color:
                            Colors.grey.shade300,
                      ),
                    ),

                    const Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 12,
                      ),

                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        color:
                            Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // SIGN UP
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const Text(
                      "Don't have an account?",
                    ),

                    TextButton(
                      onPressed:
                          isLoggingIn
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },

                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}