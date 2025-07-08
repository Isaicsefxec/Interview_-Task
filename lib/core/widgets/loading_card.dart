import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final texts = [
      'Tap to \n Build Home ',
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 180,
      decoration: BoxDecoration(
        color: scheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: AnimatedTextKit(
          animatedTexts: texts
              .map(
                (line) => TypewriterAnimatedText(
              line,
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                height: 1.3,
                fontSize: 18,
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              speed: const Duration(milliseconds: 60),
            ),
          )
              .toList(),
          repeatForever: true,
          pause: const Duration(milliseconds: 1200),
          displayFullTextOnTap: true,
        ),
      ),
    );
  }
}
