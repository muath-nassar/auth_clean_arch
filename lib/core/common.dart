import 'package:flutter/material.dart';

import 'errors/failures.dart';

void navigateWithFade(BuildContext context, Widget destination){
  Navigator.of(context).pushAndRemoveUntil(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return destination;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnimation = animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeIn),
          ),
        );
        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    ),
        (Route<dynamic> route) => false,
  );

}




// Function to display the error messages from a Failure
Widget failureMessagesColumn(Failure failure) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: failure.errors.map((error) => Text(error.toString())).toList(),
  );
}