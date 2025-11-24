import 'package:flutter/material.dart';

class FadeSlidePageRoute extends PageRouteBuilder {
  final Widget page;

  FadeSlidePageRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const beginOffset = Offset(0.0, 0.1);
          const endOffset = Offset.zero;
          final offsetTween = Tween(
            begin: beginOffset,
            end: endOffset,
          ).chain(CurveTween(curve: Curves.easeOutCubic));

          final opacityTween = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(offsetTween),
            child: FadeTransition(
              opacity: animation.drive(opacityTween),
              child: child,
            ),
          );
        },
      );
}
