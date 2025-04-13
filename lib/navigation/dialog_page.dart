import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class CustomDialogPage extends CustomTransitionPage {
  CustomDialogPage({required super.child})
    : super(
        barrierDismissible: true,
        opaque: false,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
}
