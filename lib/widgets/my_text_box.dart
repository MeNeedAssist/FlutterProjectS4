// ignore: file_names
import 'package:flutter/material.dart';
import 'package:project_s4/theme/colors.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            sectionName,
            style: TextStyle(color: primaryColor),
          ),
          SizedBox(
            width: 10,
          ),
          Text(text)
        ],
      ),
    );
  }
}
