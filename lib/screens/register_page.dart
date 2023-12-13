// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/widgets/button.dart';
import 'package:project_s4/widgets/text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final ApiService apiService = ApiService();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // Initial date

  String getFormattedDate() {
    return DateFormat('d-MM-y').format(selectedDate.toLocal());
  }

  Future<void> registerUser() async {
    try {
      // print(emailController.text.trim());
      var response = await apiService.registerUser(
        email: emailController.text.trim(),
        name: nameController.text,
        password: passwordController.text,
        dateOfBirth: selectedDate,
      );
      // print(response['email']);
      if (response) {
        print('Register Successful');
      } else {
        throw Exception('Register fail');
      }
    } catch (error) {
      String errorMessage;
      if (error is Map && error.containsKey('Error Message')) {
        errorMessage = error['Error Message'];
      } else if (error is String) {
        errorMessage = error;
      } else {
        errorMessage = 'Unknown Error Occurred';
      }
    }
  }

  Future<void> sendVerifyCode() async {
    try {
      // print(emailController.text.trim());
      var response = await apiService.sendVerifyCode(
        toEmail: emailController.text.trim(),
        subject: 'Ultimate Learning Activation',
        content: 'Your verify code is: ',
      );
      if (response) {
        print('Send Code');
        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('email', emailController.text.trim());
        await prefs?.setString('password', passwordController.text);
        emailController.clear();
        passwordController.clear();
        nameController.clear();
        context.go('/register/verify_page');
      } else {
        context.go('/register');
      }
    } catch (error) {
      String errorMessage;
      if (error is Map && error.containsKey('Error Message')) {
        errorMessage = error['Error Message'];
      } else if (error is String) {
        errorMessage = error;
      } else {
        errorMessage = 'Unknown Error Occurred';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Ultimate Learning",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Register",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Column(
                        children: [
                          MyTextFormField(
                            icons: Icon(Icons.person),
                            labelText: "Email",
                            obscureText: false,
                            textEditingController: emailController,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          MyTextFormField(
                            icons: Icon(Icons.abc_outlined),
                            labelText: "Name",
                            obscureText: false,
                            textEditingController: nameController,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          MyTextFormField(
                            icons: Icon(Icons.lock),
                            labelText: "Password",
                            obscureText: true,
                            textEditingController: passwordController,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            getFormattedDate(),
                            style: TextStyle(fontSize: 18),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Text('Select Date'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: MyButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await registerUser();
                              // print('Registration successful');
                              await sendVerifyCode();
                              // print('Verification code sent successfully');
                            } catch (error) {
                              print(
                                  'Error during registration or verification: $error');
                              // Handle errors as needed
                            }
                          }
                        },
                        text: "Register",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
