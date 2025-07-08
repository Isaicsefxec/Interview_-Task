import 'package:flutter/material.dart';

class ResponsiveUtils {
  final BuildContext context;
  final Size size;
  final double devicePixelRatio;
  final Orientation orientation;

  ResponsiveUtils(this.context)
      : size = MediaQuery.of(context).size,
        devicePixelRatio = MediaQuery.of(context).devicePixelRatio,
        orientation = MediaQuery.of(context).orientation;

  double wp(double percent) => size.width * percent / 100;
  double hp(double percent) => size.height * percent / 100;

  bool get isMobile => size.width < 600;
  bool get isTablet => size.width >= 600 && size.width < 1024;
  bool get isDesktop => size.width >= 1024;

  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
}
