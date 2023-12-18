import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/purchaseBundle.dart';
import 'package:project_s4/widgets/app_bar.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Testing2 extends StatefulWidget {
  const Testing2({super.key});

  @override
  State<Testing2> createState() => _Testing2State();
}

class _Testing2State extends State<Testing2> with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ApiService _apiSer = ApiService();

  String qrResult = 'Scanned Data will appear here';
  late PurchaseBundle bundle;
  bool scaned = false;
  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (!mounted) {
        return;
      }
      final Map<String, dynamic> jsonResponse = jsonDecode(qrCode);
      bundle = PurchaseBundle.fromJson(jsonResponse);
      // print(bundle.description);
      scaned = true;
      notifyListeners();
    } on PlatformException {
      if (mounted) {
        setState(() {
          qrResult = 'Fail to read QR code';
        });
      }
    }
  }

  void printSth() {
    print('Purchase Success');
  }

  @override
  void dispose() {
    // Perform any cleanup operations here
    super.dispose(); // Make sure to call super.dispose()
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this,
      child: SafeArea(
        child: Scaffold(
          appBar: MyAppBar(text: 'Ultimate Learning'),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Consumer<_Testing2State>(
                  builder: (context, model, _) {
                    return model.scaned
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.diamond),
                              Text(
                                '${model.bundle.gem}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          )
                        : Container();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Consumer<_Testing2State>(
                  builder: (context, model, _) {
                    return model.scaned
                        ? Text(
                            '\$${model.bundle.price}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          )
                        : Container();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Consumer<_Testing2State>(
                  builder: (context, model, _) {
                    return !model.scaned
                        ? ElevatedButton(
                            onPressed: model.scanQR,
                            child: Text('Scan Code'),
                          )
                        : Container();
                  },
                ),
                Consumer<_Testing2State>(
                  builder: (context, model, _) {
                    return model.scaned
                        ? TextButton(
                            onPressed: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => UsePaypal(
                                    sandboxMode: true,
                                    clientId:
                                        "AcNyCFolvTV9M5vlw974qLJNkK972ybFYzZyMDqTqtecjGqeSDDGQQfbgZyA0GG0Phg0NDwmTcZXwI38",
                                    secretKey:
                                        "EH4lyMoVM5BLHDl8iPkrH1eBai2ZiU4nGwEWBm_IEx2rp1BeE0vREKmAcbjbyPeEPx6Knwh-Iso2vpYO",
                                    returnURL: "https://samplesite.com/return",
                                    cancelURL: "https://samplesite.com/cancel",
                                    transactions: [
                                      {
                                        "amount": {
                                          "total": '${bundle.price}',
                                          "currency": "USD",
                                        },
                                        "description": bundle.description,
                                      }
                                    ],
                                    note:
                                        "Contact us for any questions on your order.",
                                    onSuccess: (Map params) async {
                                      final SharedPreferences? prefs =
                                          await _prefs;
                                      final token =
                                          prefs?.get('token') as String;
                                      await model._apiSer.purchaseGem(
                                        gem: model.bundle.gem,
                                        token: token,
                                      );
                                      printSth();
                                      model.notifyListeners();
                                    },
                                    onError: (error) {
                                      print("onError: $error");
                                    },
                                    onCancel: (params) {
                                      print('cancelled: $params');
                                    },
                                  ),
                                ),
                              )
                              // .then((value) => {
                              //       Navigator.of(context).push(
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   HomePage()))
                              //     }),
                            },
                            child: const Text("Confirm Payment"),
                          )
                        : Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
