import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we/services/authenticate.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/Styles/decoration.dart';
import 'package:we/shared/loading.dart';
import 'package:we/shared/size_config.dart';

class SignIn extends StatefulWidget {
  Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String resetEmail = "";
  String email = "";
  String password = "";

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
                padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical*5, horizontal: SizeConfig.safeBlockVertical*4),
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
                              padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockHorizontal*10, horizontal: SizeConfig.safeBlockHorizontal*8,),
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
                                    'L O G I N',
                                    style: AppStyles.appTextHeading2(AppColors.Yellow,FontWeight.w300),
                                  ),
                                  SizedBox(height: SizeConfig.safeBlockHorizontal*8,),
                                  TextFormField(
                                  //  style: TextStyle(fontSize: 17),
                                    textAlign: TextAlign.start,
                                    decoration: InputDecoration(
                                      prefixIcon: AppStyles.iconStyling(Icons.email_outlined, AppColors.Yellow),
                                      hintText: 'Email',
                                      alignLabelWithHint: true,

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
                                    //style: TextStyle(fontSize: 17),
                                    textAlign: TextAlign.start,
                                    decoration: InputDecoration(
                                      prefixIcon: AppStyles.iconStyling(Icons.lock_outlined, AppColors.Yellow),
                                      hintText: 'Password',
                                      alignLabelWithHint: true,

                                      fillColor: Colors.green,

                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.safeBlockVertical*4,
                                  ),
                                  Container(

                                    child: RaisedButton(
                                        elevation: 0,
                                        color: AppColors.Yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),

                                        ),
                                        padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical*2,horizontal: SizeConfig.safeBlockHorizontal*8),
                                        onPressed: () async {
                                          if (_formKey.currentState.validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            dynamic result =
                                            await _auth.signInWithEmailAndPassword(
                                                email, password);
                                            if (result == null) {
                                              setState(() {
                                                loading = false;
                                                error = 'invalid credentials';
                                              });
                                            }
                                          }
                                        },
                                        // color: Colors.purple[500],

                                        child: Text("Sign In", style: AppStyles.appTextHeading(AppColors.White, FontWeight.w300),)
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical*6,),
                      Text(error, style: TextStyle(color: Colors.red)),

                      InkWell(
                          child: Text("Forgot Password?",
                          style: AppStyles.appTextRegular(AppColors.suggestionGrey)),
                          onTap: () {
                            if (email == "") {
                              Fluttertoast.showToast(
                                backgroundColor: AppColors.Yellow,
                                textColor: AppColors.White,
                                msg: "Enter your email",
                                fontSize:   SizeConfig.safeBlockVertical*2,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Password Reset",
                                        style: AppStyles.appTextHeading(AppColors.Black,FontWeight.w300),
                                      ),
                                      content: RichText(
                                        text: TextSpan(
                                          text: "The password reset email will be sent to ",
                                          style: AppStyles.appTextRegular(AppColors.Black),
                                          children: [
                                            TextSpan(
                                              text: email,
                                              style: AppStyles.appTextRegular(AppColors.Yellow)
                                            ),
                                            TextSpan(
                                              text: ". Click OK to proceed.",
                                              style: AppStyles.appTextRegular(AppColors.Black)
                                            )
                                          ]
                                        ),),
                                      actions: [
                                        FlatButton(
                                          child: Text("OK",style: AppStyles.appTextHeading(AppColors.Yellow,FontWeight.w300)),
                                          onPressed: () {
                                            _auth.resetPassword(email);
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                              backgroundColor: AppColors.Yellow,
                                              textColor: AppColors.White,
                                              msg:
                                                  "Check your email for instructions",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                            );
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
                          }),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical*3,
                      ),



                      InkWell(
                        child: Text(
                          "Register",
                          style: AppStyles.appTextHeading(AppColors.Yellow, FontWeight.w300),
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