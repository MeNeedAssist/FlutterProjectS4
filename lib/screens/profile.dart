import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/user.dart';
import 'package:project_s4/theme/colors.dart';
import 'package:project_s4/utils/api_endpoint.dart';
import 'package:project_s4/widgets/my_text_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ApiService apiService = ApiService();
  bool isLoading = true;
  late User userInfo;
  late User userGameData;

  Future<void> getInfo() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      final userId = prefs?.get('userId') as int;
      final email = prefs?.get('email') as String;
      final password = prefs?.get('password') as String;
      var response = await apiService.loginWebAccount(
        email,
        password,
      );
      final Map<String, dynamic> jsonResponse = (response['user']);
      // final Map<String, dynamic> lessonData = jsonResponse;
      userInfo = User.fromJson(jsonResponse);
      // userInfo = jsonDecode(response['user']);
      final User userGem = await apiService.getUserGemData(userId: userId);
      userGameData = userGem;
      isLoading = false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                          radius: 20, // Adjust the radius as needed
                          backgroundImage: Image.network(
                                  '${ApiEndPoints.backendUrl}${userInfo.avatar}')
                              .image,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(userInfo.name!),
                      SizedBox(
                        height: 10,
                      ),
                      Text(userInfo.email!),
                      SizedBox(
                        height: 10,
                      ),
                      Text(DateFormat('d-MM-y')
                          .format(userInfo.dateOfBirth!.toLocal())),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            side: BorderSide.none,
                            shape: StadiumBorder(),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {
                            final SharedPreferences? prefs = await _prefs;
                            prefs?.clear();
                            context.go('/');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: complementaryColor,
                            side: BorderSide.none,
                            shape: StadiumBorder(),
                          ),
                          child: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      MyTextBox(
                        text: '${userGameData.level}',
                        sectionName: 'Lv:',
                      ),
                      MyTextBox(
                        text: '${userGameData.gem}',
                        sectionName: 'Gem:',
                      ),
                      MyTextBox(
                        text: '${userGameData.earned}',
                        sectionName: 'Earned:',
                      ),
                      MyTextBox(
                        text: '${userGameData.spent}',
                        sectionName: 'Spent:',
                      ),
                      MyTextBox(
                        text: '${userGameData.exp}',
                        sectionName: 'Exp:',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Text('isLoading');
  }
}
