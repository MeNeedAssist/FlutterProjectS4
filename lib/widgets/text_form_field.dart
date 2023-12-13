// import 'package:email_validator/email_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final Icon icons;
  final String labelText;
  final bool obscureText;
  final TextEditingController textEditingController;

  const MyTextFormField({
    super.key,
    required this.icons,
    required this.labelText,
    required this.obscureText,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: textEditingController,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: icons,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          labelText: labelText,
        ),
        validator: (String? value) {
          if (labelText == "Email") {
            if (value == null || value.isEmpty) {
              return 'Please enter email address';
            }
            if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          } else {
            if (value == null || value.isEmpty) {
              return 'Please enter the ${labelText.toLowerCase()} field';
            }
            if (labelText == "Password") {
              if (value.length < 6) {
                return 'Password must be > 6 character';
              }
            }
            return null;
          }
        },
      ),
    );
  }
}
