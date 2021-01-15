import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:we/services/database.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/Styles/decoration.dart';
import 'package:we/shared/size_config.dart';

class VerifyEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = Provider.of<User>(context);
    DatabaseService _db = DatabaseService();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 200),
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
             // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Image.asset('assets/images/welogotry5.png', width : 100, height : 200),
            Text('Please check your email for the verification link', style: AppStyles.appTextRegular(Colors.black),),
            SizedBox(
              height: SizeConfig.safeBlockHorizontal*10,
            ),
            RaisedButton(
              elevation: 1,
              color: AppColors.Yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),

              ),
                child: Text("I verified", style: AppStyles.appTextHeading(AppColors.White, FontWeight.w300),),
              padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical*2,horizontal: SizeConfig.safeBlockHorizontal*8),
              onPressed: () async {
                await _auth.signOut();
                Fluttertoast.showToast(
                  msg: "Please sign in to continue.",
                  backgroundColor: AppColors.Yellow,
                  textColor: AppColors.White,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
