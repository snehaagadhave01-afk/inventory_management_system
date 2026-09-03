import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.textInputAction,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : maxLines,

      decoration: InputDecoration(
        hintText: hintText,

        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xff2962FF),
        ),

        suffixIcon: suffixIcon,

        filled: true,
        fillColor: Colors.white,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide:
              const BorderSide(
            color: Colors.black26,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide:
              const BorderSide(
            color: Colors.black26,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide:
              const BorderSide(
            color: Color(0xff2962FF),
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide:
              const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide:
              const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}