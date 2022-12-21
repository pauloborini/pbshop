import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget small;
  final Widget medium;
  final Widget large;
  final Widget xlarge;

  const Responsive({
    Key? key,
    required this.small,
    required this.medium,
    required this.large,
    required this.xlarge,
  }) : super(key: key);

  static bool isXTest(BuildContext context) =>
      MediaQuery.of(context).size.height <= 200 ||
      MediaQuery.of(context).size.width <= 300;

  static bool isTest(BuildContext context) =>
      MediaQuery.of(context).size.height <= 400 ||
      MediaQuery.of(context).size.width <= 440;

  static bool isSmall(BuildContext context) =>
      MediaQuery.of(context).size.width <= 500;

  static bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.width <= 700;

  static bool isLarge(BuildContext context) =>
      MediaQuery.of(context).size.width < 1024;

  static bool isXLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= 1024) {
      return xlarge;
    } else if (size.width >= 700 && large != null) {
      return large!;
    } else if (size.width >= 500 && medium != null) {
      return medium!;
    } else {
      return small;
    }
  }
}
