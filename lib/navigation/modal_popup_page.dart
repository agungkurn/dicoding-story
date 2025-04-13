import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class CustomModalPopupPage extends CustomTransitionPage {
  CustomModalPopupPage({required Widget child})
    : super(
        barrierDismissible: true,
        opaque: false,
        transitionDuration: const Duration(milliseconds: 300),
        child: SafeArea(
          child: Align(alignment: Alignment.bottomCenter, child: child),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}
