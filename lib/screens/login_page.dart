import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/widgets/button.dart';
import 'package:project_s4/widgets/text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> loginWithEmail() async {
    try {
      var response = await apiService.loginWebAccount(
        emailController.text.trim(),
        passwordController.text,
      );

      // Check if 'token' is present in the response
      if (response.containsKey('token')) {
        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('email', emailController.text.trim());
        await prefs?.setString('password', passwordController.text);
        await prefs?.setString('token', response['token']);
        await prefs?.setInt('userId', response['user']['userId']);
        print(response['token']);
        emailController.clear();
        passwordController.clear();
        context.go('/homepage');
      } else {
        throw Exception('Token not found in response');
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
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                      "Login",
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
                            icons: Icon(Icons.lock),
                            labelText: "Password",
                            obscureText: true,
                            textEditingController: passwordController,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        children: [
                          MyButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                loginWithEmail();
                              }
                            },
                            text: "Login",
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Not a member?'),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                child: Text(
                                  "Register now",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {
                                  GoRouter.of(context).go('/register');
                                },
                              ),
                            ],
                          )
                        ],
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
