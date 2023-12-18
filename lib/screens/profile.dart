// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/purchaseBundle.dart';
import 'package:project_s4/model/user.dart';
import 'package:project_s4/screens/homepage.dart';
import 'package:project_s4/theme/colors.dart';
import 'package:project_s4/utils/api_endpoint.dart';
import 'package:project_s4/widgets/my_text_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

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
  File? _selectedImage;
  DateTime selectedDate = DateTime.now(); // Initial date
  late PurchaseBundle selectedBundle;
  late List<PurchaseBundle> bundles = [
    PurchaseBundle(
        id: 0,
        price: 1,
        gem: 50,
        description: 'Description of Starter bundle.'),
    PurchaseBundle(
        id: 1,
        price: 4.12,
        gem: 400,
        description: 'Description of Middle bundle.'),
    PurchaseBundle(
        id: 2,
        price: 15.33,
        gem: 2000,
        description: 'Description of Senior bundle.'),
  ];
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

  Future<void> _showEditProfileDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String? validateNotNull(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    String getFormattedDate() {
      return DateFormat('d-MM-y')
          .format(selectedDate.toLocal().subtract(Duration(days: 18 * 365)));
    }

    nameController.text = userInfo.name ?? '';
    emailController.text = userInfo.email ?? '';

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Edit Profile'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: _selectedImage != null
                                  ? Image.file(_selectedImage!).image
                                  : Image.network(
                                          '${ApiEndPoints.backendUrl}${userInfo.avatar}')
                                      .image,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () async {
                                  final returnedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (returnedImage == null) return;
                                  setState(() {
                                    _selectedImage = File(returnedImage.path);
                                  });
                                },
                                icon: Icon(Icons.camera_alt),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: validateNotNull,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextFormField(
                      controller: emailController,
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      getFormattedDate(),
                      style: TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime currentDate = DateTime.now();
                        final DateTime eighteenYearsAgo =
                            currentDate.subtract(Duration(days: 18 * 365));
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1950),
                          lastDate: currentDate,
                        );
                        if (picked != null && picked != selectedDate) {
                          if (picked.isAfter(eighteenYearsAgo)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Selected date must be at least 18 years ago.'),
                              ),
                            );
                          } else {
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
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final SharedPreferences? prefs = await _prefs;
                    final token = prefs?.get('token') as String;
                    var newImage = '';

                    if (_selectedImage != null) {
                      newImage = await apiService.uploadFile(
                        file: _selectedImage,
                        folderName: 'user',
                        folderPath: 'images/user',
                      );
                    }

                    await apiService.updateProfile(
                      userId: userInfo.userId,
                      email: emailController.text,
                      name: nameController.text,
                      dateOfBirth: selectedDate,
                      avatar: (newImage == '') ? userInfo.avatar! : newImage,
                      token: token,
                    );
                    Navigator.of(context).pop();
                    await getInfo();
                  }
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getInfo();
    selectedBundle = PurchaseBundle(id: -1, price: 0, gem: 0, description: '');
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
                          onPressed: () async {
                            await _showEditProfileDialog(context);
                          },
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
                          onPressed: () {
                            // Show a dialog with the image and selectedBundle information
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) => AlertDialog(
                                    title: Text('Purchase Gem'),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // Display all three images with GestureDetector
                                        Container(
                                          decoration: BoxDecoration(
                                            color: selectedBundle != null &&
                                                    selectedBundle.id == 0
                                                ? Colors.grey[300]
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.black,
                                            ), // Adjust the radius as needed
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedBundle = bundles[0];
                                              });
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  8.0), // Same as the container's borderRadius
                                              child: Image.asset(
                                                'images/assets/gem-bundle-1.png',
                                                width: 100,
                                                height: 100,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: selectedBundle != null &&
                                                    selectedBundle.id == 1
                                                ? Colors.grey[300]
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedBundle = bundles[1];
                                              });
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                'images/assets/gem-bundle-2.png',
                                                width: 100,
                                                height: 100,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: selectedBundle != null &&
                                                    selectedBundle.id == 2
                                                ? Colors.grey[300]
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedBundle = bundles[2];
                                              });
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                'images/assets/gem-bundle-3.png',
                                                width: 100,
                                                height: 100,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Price: ${selectedBundle.price}',
                                            ),
                                            Text(
                                              'Gem: ${selectedBundle.gem}',
                                            ),
                                            Text(
                                              'Description: ${selectedBundle.description}',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          selectedBundle = PurchaseBundle(
                                              id: -1,
                                              price: 0,
                                              gem: 0,
                                              description: '');
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        child: Text('Close'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                PaypalCheckoutView(
                                              sandboxMode: true,
                                              clientId:
                                                  "AcNyCFolvTV9M5vlw974qLJNkK972ybFYzZyMDqTqtecjGqeSDDGQQfbgZyA0GG0Phg0NDwmTcZXwI38",
                                              secretKey:
                                                  "EH4lyMoVM5BLHDl8iPkrH1eBai2ZiU4nGwEWBm_IEx2rp1BeE0vREKmAcbjbyPeEPx6Knwh-Iso2vpYO",
                                              transactions: [
                                                {
                                                  "amount": {
                                                    "total":
                                                        '${selectedBundle.price}',
                                                    "currency": "USD",
                                                  },
                                                  "description": selectedBundle
                                                      .description,
                                                }
                                              ],
                                              note:
                                                  "Contact us for any questions on your order.",
                                              onSuccess: (Map params) async {
                                                final SharedPreferences? prefs =
                                                    await _prefs;
                                                final token = prefs
                                                    ?.get('token') as String;
                                                var buyGem = await apiService
                                                    .purchaseGem(
                                                  gem: selectedBundle.gem,
                                                  token: token,
                                                );
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('Notification'),
                                                      content: Text(buyGem),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyProfilePage(),
                                                              ),
                                                            ); // Close the dialog
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              onError: (error) {
                                                print("onError: $error");
                                                Navigator.pop(context);
                                              },
                                              onCancel: () {
                                                print('cancelled:');
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ));
                                        },
                                        child: const Text('Purchase'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            side: BorderSide.none,
                            shape: StadiumBorder(),
                          ),
                          child: Text(
                            'Buy Gem',
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
