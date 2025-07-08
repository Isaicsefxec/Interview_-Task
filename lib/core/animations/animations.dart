import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animate_do/animate_do.dart';

class AppAnimations {
  /// Fade In Animation
  static Widget fadeIn(
      Widget child, {
        int durationMs = 500,
        Curve curve = Curves.easeIn,
      }) {
    return child.animate().fadeIn(
      duration: Duration(milliseconds: durationMs),
      curve: curve,
    );
  }

  /// Slide Up with Fade
  static Widget slideInUp(
      Widget child, {
        int durationMs = 500,
        Curve curve = Curves.easeOut,
      }) {
    return child.animate().slideY(
      begin: 0.3,
      end: 0,
      curve: curve,
      duration: Duration(milliseconds: durationMs),
    ).fadeIn(duration: Duration(milliseconds: durationMs));
  }

  /// Bounce In (using animate_do)
  static Widget bounceIn(
      Widget child, {
        int durationMs = 600,
        Curve curve = Curves.bounceOut,
      }) {
    return BounceIn(
      duration: Duration(milliseconds: durationMs),
      child: child,
    );
  }

  /// Shake (e.g. on error)
  static Widget shake(
      Widget child, {
        int durationMs = 600,
      }) {
    return ShakeX(
      duration: Duration(milliseconds: durationMs),
      child: child,
    );
  }

  /// Zoom In
  static Widget zoomIn(
      Widget child, {
        int durationMs = 500,
      }) {
    return child.animate()
        .scale(
      begin: const Offset(0.7, 0.7),
      end: const Offset(1.0, 1.0),
      duration: Duration(milliseconds: durationMs),
    )
        .fadeIn(duration: Duration(milliseconds: durationMs));
  }

  /// Scale with Elastic Effect
  static Widget elasticScale(
      Widget child, {
        int durationMs = 700,
      }) {
    return ElasticIn(
      duration: Duration(milliseconds: durationMs),
      child: child,
    );
  }
  static Widget fadeSlideIn({
    required Widget child,
    int durationMs = 300,
    Offset beginOffset = const Offset(0, 0.1),
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: beginOffset, end: Offset.zero),
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, value.dy * 100),
          child: AnimatedOpacity(
            opacity: value == Offset.zero ? 1.0 : 0.0,
            duration: Duration(milliseconds: durationMs),
            child: child,
          ),
        );
      },
    );
  }
  /// Delay chain animations
  static Widget delay(
      Widget child, {
        int delayMs = 300,
      }) {
    return child.animate(delay: Duration(milliseconds: delayMs));
  }
}
