import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we/screens/landing_page.dart';
import 'package:we/services/authenticate.dart';
import 'package:we/shared/size_config.dart';

void main() async {
  //initialise firebase app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color(0xFFFFC959),

        accentColor: Color(0xFFFFC959),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(12),
          hintStyle: GoogleFonts.montserrat(fontSize: 15, color: Colors.grey[300], fontWeight: FontWeight.w200),
          labelStyle: GoogleFonts.montserrat( fontSize: 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Color(0xFFFFC959)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.grey[300]),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(color: Color(0xFFFFC959), size: 30),
          unselectedIconTheme:
              IconThemeData(color: Color(0xFF993366), size: 30),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
        ),
      ),
      home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //StreamProvider for sign in/ sign out events
    return StreamProvider.value(
      value: AuthService().user,
      child: LandingPage(),
    );
  }
}
