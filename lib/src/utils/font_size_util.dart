import 'package:flutter/material.dart';

class FontSizeUtil {
  static TextScaler _scale(BuildContext context) =>
      MediaQuery.of(context).textScaler;

  static double font1(BuildContext context) => _scale(context).scale(36);

  static double font2(BuildContext context) => _scale(context).scale(30);

  static double font3(BuildContext context) => _scale(context).scale(24);

  static double font4(BuildContext context) => _scale(context).scale(18);

  static double font5(BuildContext context) => _scale(context).scale(12);
}
