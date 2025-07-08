import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color? color;

  const AppText(
      this.text, {
        this.size = 16,
        this.weight = FontWeight.w500,
        this.color,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}
