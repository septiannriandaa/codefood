import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget spaceHeight(height) {
  return SizedBox(
    height: height,
  );
}

Widget spaceWidth(width) {
  return SizedBox(
    width: width,
  );
}

String dateFormatterDefault(DateTime date) {
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  final String formatted = formatter.format(date);
  return formatted;
}
