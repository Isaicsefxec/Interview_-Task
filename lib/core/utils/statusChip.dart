import 'package:flutter/material.dart';
import 'app_colors.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'available':
        color = AppColors.statusAvailable;
        break;
      case 'sold':
        color = AppColors.statusSold;
        break;
      case 'upcoming':
        color = AppColors.statusUpcoming;
        break;
      default:
        color = AppColors.info;
    }

    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
      side: BorderSide(color: color),
    );
  }
}
