import 'package:flutter/material.dart';

var primaryColor = Color.fromARGB(255, 138, 60, 55);

var complementaryColor = Color.fromARGB(
  primaryColor.alpha,
  (255 - primaryColor.red),
  (255 - primaryColor.green),
  (255 - primaryColor.blue),
);
