// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool isRegister = false;
  final _formKey = GlobalKey<FormState>();

  final ApiService apiService = ApiService();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DateTime selectedDate =
      DateTime.now().subtract(Duration(days: 18 * 365)); // Initial date

  String getFormattedDate() {
    return DateFormat('d-MM-y').format(selectedDate.toLocal());
  }

  Future<void> registerUser() async {
    try {
      setState(() {
        isRegister = true;
      });
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
        deevLink: 'http://localhost3000/login',
        action: 'Confirm Account',
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
                      height: 15,
                    ),
                    Text(
                      "Register",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SvgPicture.asset(
                      'images/assets/logo.svg',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
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
                              final DateTime currentDate = DateTime.now();
                              final DateTime eighteenYearsAgo = currentDate
                                  .subtract(Duration(days: 18 * 365));
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(1950),
                                lastDate: currentDate,
                              );
                              if (picked != null && picked != selectedDate) {
                                if (picked.isAfter(eighteenYearsAgo)) {
                                  // Show an error message if the selected date is not at least 18 years ago
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Selected date must be at least 18 years ago.'),
                                    ),
                                  );
                                } else {
                                  // Set the selected date if it's valid
                                  setState(
                                    () {
                                      selectedDate = picked;
                                    },
                                  );
                                }
                              }
                            },
                            child: Text('Select Date'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: !isRegister
                          ? MyButton(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await registerUser();
                                    // print('Registration successful');
                                    await sendVerifyCode();
                                    // print('Verification code sent successfully');
                                  } catch (error) {
                                    // Handle errors as needed
                                  }
                                }
                              },
                              text: "Register",
                            )
                          : Center(
                              child: CircularProgressIndicator(),
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
