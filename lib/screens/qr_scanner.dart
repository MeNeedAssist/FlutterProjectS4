import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/purchaseBundle.dart';
import 'package:project_s4/screens/homepage.dart';
import 'package:project_s4/widgets/app_bar.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
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
      setState(() {});
    } on PlatformException {
      if (mounted) {
        setState(() {
          qrResult = 'Fail to read QR code';
        });
      }
    }
  }

  @override
  void dispose() {
    // Perform any cleanup operations here
    super.dispose(); // Make sure to call super.dispose()
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(text: 'Ultimate Learning'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              scaned
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.diamond),
                        Text(
                          '${bundle.gem}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              scaned
                  ? Text(
                      '\$${bundle.price}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 30,
              ),
              scaned
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => PaypalCheckoutView(
                            sandboxMode: true,
                            clientId:
                                "AcNyCFolvTV9M5vlw974qLJNkK972ybFYzZyMDqTqtecjGqeSDDGQQfbgZyA0GG0Phg0NDwmTcZXwI38",
                            secretKey:
                                "EH4lyMoVM5BLHDl8iPkrH1eBai2ZiU4nGwEWBm_IEx2rp1BeE0vREKmAcbjbyPeEPx6Knwh-Iso2vpYO",
                            transactions: [
                              {
                                "amount": {
                                  "total": '${bundle.price}',
                                  "currency": "USD",
                                },
                                "description": bundle.description,
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              final SharedPreferences? prefs = await _prefs;
                              final token = prefs?.get('token') as String;
                              var buyGem = await _apiSer.purchaseGem(
                                gem: bundle.gem,
                                token: token,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(buyGem),
                                ),
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
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
                      child: const Text('Pay with paypal'),
                    )
                  : Container(),
              !scaned
                  ? ElevatedButton(
                      onPressed: scanQR,
                      child: Text('Scan Code'),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
