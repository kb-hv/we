import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we/screens/auth/auth_wrapper.dart';
import 'package:we/screens/auth/email_verify.dart';
import 'package:we/screens/home/home_wrapper.dart';
import 'package:we/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
   FirebaseFirestore firestore = FirebaseFirestore.instance;
    DatabaseService _db = DatabaseService();
    if (user != null)  {
      if(!user.emailVerified){
          return VerifyEmail();
      } else {
        Future.delayed(const Duration(seconds: 1));
        return FutureProvider<bool>(
          create: (context) {
            return _db.isUserAdmin();
          },
          child: HomeWrapper(),
        );
      }
    } else {
      return AuthWrapper();
    }
  }
}