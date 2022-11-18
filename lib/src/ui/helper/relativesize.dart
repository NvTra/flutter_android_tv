import 'package:flutter/widgets.dart';

class RelativeSize {
  static const double _referenceScreenWidth = 1920;
  static const double _referenceScreenHeight = 1080;

  static double screenWidth = _referenceScreenWidth;
  static double screenHeight = _referenceScreenHeight;
  static double factor = 1;

  static void init(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    factor = screenHeight / _referenceScreenHeight;
  }

  static double get(double value) => value * factor;

  static EdgeInsets fromLTRB(double left, double top,
      double right, double bottom) {
    return EdgeInsets.fromLTRB(get(left), get(top),
        get(right), get(bottom));
  }

  static EdgeInsets only({double left = 0, double top = 0,
    double right = 0, double bottom = 0}) {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  static EdgeInsets all(double a) => EdgeInsets.fromLTRB(a, a, a, a);
}