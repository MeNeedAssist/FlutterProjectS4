import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final ApiService apiService = ApiService();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<TextEditingController> controllers =
      List.generate(5, (_) => TextEditingController());
  String pinCode = '';

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> enterVerifyCode() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      final email = prefs?.get('email') as String;
      final password = prefs?.get('password') as String;
      var response = await apiService.activeUser(email: email, code: pinCode);
      var responseLogin = await apiService.loginWebAccount(email, password);
      if (response && responseLogin.containsKey('token')) {
        await prefs?.setString('token', responseLogin['token']);
        await prefs?.setInt('userId', responseLogin['user']['userId']);
        context.go('/homepage');
        print(email);
        print(password);
        print(responseLogin['token']);
        print(responseLogin['user']['userId']);
        print('active success');
      } else {
        controllers.clear;
        throw Exception('Active fail');
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
      print(errorMessage);
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
              child: Column(
                children: [
                  Text(
                    "Ultimate Learning",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter Verify Code",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        controllers.length,
                        (index) => SizedBox(
                          height: 64,
                          width: 68,
                          child: TextFormField(
                            controller: controllers[index],
                            autofocus: index == 0,
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                              if (index == controllers.length - 1 &&
                                  value.length == 1) {
                                // The last box is filled, trigger your function
                                pinCode = controllers
                                    .map((controller) => controller.text)
                                    .join();
                                print(pinCode);
                                enterVerifyCode();
                                // Call your function here with the concatenated pin code
                              }
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
