import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we/services/authenticate.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/Styles/decoration.dart';
import 'package:we/shared/loading.dart';
import 'package:we/shared/size_config.dart';

class Register extends StatefulWidget {
  Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String email = "";
  String password = "";
  String phone = "";

  String error = "";

  //loading screen will be displayed based on this value
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: AppColors.White,
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/welogotry5.png', ),
          //
          //   )
          // ),
          padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical*3, horizontal: SizeConfig.safeBlockHorizontal*5),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.safeBlockVertical*20,
                ),
                // Text(
                //   'Login',
                //   style: TextStyle(fontSize: 40, color: Colors.black),
                // ),

                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Positioned(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*8,vertical: SizeConfig.safeBlockHorizontal*10,
                ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                color: AppColors.suggestionGrey,
                                offset: Offset(0, 1))
                          ],
                          // border: Border.all(color: Colors.purple[50])
                        ),
                        child: Column(
                          children: [
                            Text(
                              'REGISTER',
                              style: AppStyles.appTextHeading2(AppColors.Yellow,FontWeight.w300),
                            ),

                            SizedBox(height: SizeConfig.safeBlockHorizontal*8,),
                            TextFormField(
                             // style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                prefixIcon: AppStyles.iconStyling(Icons.person_outline_sharp, AppColors.Yellow),
                                hintText: 'Username',
                                alignLabelWithHint: true,


                              ),
                              onChanged: (val) {
                                setState(() {
                                  username = val;
                                });
                              },
                              validator: (val) =>
                              val.isEmpty ? 'Enter username' : null,
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical*3,
                            ),
                            TextFormField(
                             // style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                prefixIcon: AppStyles.iconStyling(Icons.email_outlined, AppColors.Yellow),
                                hintText: 'Email',
                                alignLabelWithHint: true,
                                // labelStyle: AppStyles.appTextRegular(
                                //     AppColors.suggestionGrey),
                                //fillColor: Colors.green,

                              ),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              validator: (val) =>
                              val.isEmpty ? 'Enter email' : null,
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical*3,
                            ),
                            TextFormField(
                              obscureText: true,
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              validator: (val) => val.isEmpty
                                  ? 'Enter password'
                                  : null,
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                prefixIcon: AppStyles.iconStyling(Icons.lock_outlined, AppColors.Yellow),
                                hintText: 'Password',
                                alignLabelWithHint: true,
                                // labelStyle: AppStyles.appTextRegular(
                                //     AppColors.suggestionGrey),
                                fillColor: Colors.green,

                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical*3,
                            ),
                            TextFormField(
                          //    style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                prefixIcon: AppStyles.iconStyling(Icons.phone, AppColors.Yellow),
                                hintText: 'Phone Number',
                                alignLabelWithHint: true,
                                // labelStyle: AppStyles.appTextRegular(
                                //     AppColors.suggestionGrey),
                                //fillColor: Colors.green,

                              ),
                              onChanged: (val) {
                                setState(() {
                                  phone = val;
                                });
                              },
                              validator: (val) => val.length != 10 ? 'Enter valid phone number ' : null,
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical*4,
                            ),
                            Container(

                              child: RaisedButton(
                                  elevation: 0,
                                  color: AppColors.Yellow,
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(12.0),

                                   ),
                                  padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical*2,horizontal: SizeConfig.safeBlockHorizontal*8),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _auth.registerWithEmailAndPassword(email, password, username, phone);

                                      if (result == null) {
                                        setState(() {
                                          loading = false;
                                          error = 'invalid email';
                                        });
                                      }
                                    }
                                  },
                                  // color: Colors.purple[500],

                                  child: Text("Sign Up", style: AppStyles.appTextHeading(AppColors.White, FontWeight.w300),)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),



                  ],
                ),
                SizedBox(height: SizeConfig.safeBlockVertical*4),
                Text(error, style: AppStyles.appTextRegular(AppColors.Yellow)),


                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical*3),
                    child: Text(
                      "Login",
                      style: AppStyles.appTextHeading(AppColors.Yellow, FontWeight.w300),
                    ),
                  ),
                  onTap: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}