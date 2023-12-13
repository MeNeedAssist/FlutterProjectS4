// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:project_s4/screens/qr_scanner.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  const MyAppBar({super.key, required this.text});

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => QRScanner()));
          },
          icon: const Icon(Icons.qr_code_scanner),
        ),
      ],
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }
}
