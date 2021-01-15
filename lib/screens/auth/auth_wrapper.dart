import 'package:flutter/material.dart';
import 'package:we/screens/auth/register.dart';
import 'package:we/screens/auth/sign_in.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

  bool showSignIn = true;
  void toggleView () {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignIn(toggleView: toggleView) : Register(toggleView: toggleView);
  }
}