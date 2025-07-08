import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';


class PropertyUtils {
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppColors.statusAvailable;
      case 'sold':
        return AppColors.statusSold;
      case 'upcoming':
        return AppColors.statusUpcoming;
      default:
        return AppColors.textLight;
    }
  }
}
