import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF2C3E50);
const Color kSecondaryColor = Color(0xFF2980B9);
const Color kBackgroundColor = Color(0xFFF4F6F8);
const Color kTextColor = Colors.black87;
const double kPadding = 16.0;

class AppColors {
  static const primary = Color(0xFF0062FF);
  static const accent = Color(0xFFBDF42A);
  static const background = Color(0xFFF6F6F6);
  static const white = Colors.white;
  static const black = Colors.black;
  static const grey = Colors.grey;
  static const lightGrey = Color(0xFFE0E0E0);
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFF44336);
}

class AppTextStyles {
  static TextStyle heading(BuildContext context) => TextStyle(
    fontSize: MediaQuery.of(context).size.width * 0.05,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle subheading(BuildContext context) => TextStyle(
    fontSize: MediaQuery.of(context).size.width * 0.045,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: MediaQuery.of(context).size.width * 0.035,
    color: AppColors.grey,
  );

  static TextStyle button(BuildContext context) => TextStyle(
    fontSize: MediaQuery.of(context).size.width * 0.04,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
}

class AppSizes {
  static double defaultPadding(BuildContext context) => MediaQuery.of(context).size.width * 0.04;
  static double cornerRadius(BuildContext context) => MediaQuery.of(context).size.width * 0.03;
  static double cardElevation(BuildContext context) => 4.0;
  static double iconSize(BuildContext context) => MediaQuery.of(context).size.width * 0.08;
}
