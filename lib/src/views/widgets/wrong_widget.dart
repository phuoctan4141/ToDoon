// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';

void wrongWidget(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    // ignore: unnecessary_string_interpolations
    content: Text('${Language.instance.Wrong}'),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 3),
  ));
}
