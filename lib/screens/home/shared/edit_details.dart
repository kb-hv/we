import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we/models/user.dart';
import 'package:we/services/authenticate.dart';

import 'package:we/services/database.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/Styles/decoration.dart';
import 'package:we/shared/size_config.dart';

class EditDetails extends StatefulWidget {
  @override
  _EditDetailsState createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  DatabaseService _db = DatabaseService();
  UserModel user = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.White,
      body: EditDetailsView(

      ),
    );
  }
}

class EditDetailsView extends StatefulWidget {
  @override
  _EditDetailsViewState createState() => _EditDetailsViewState();
}

class _EditDetailsViewState extends State<EditDetailsView> {
  DatabaseService _db = DatabaseService();
  UserModel user = null;
  String username = "";
  String phone = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _db.getCurrentUserModel(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel user = snapshot.data;
          return Padding(
            padding: EdgeInsets.only(left:SizeConfig.safeBlockVertical*3),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(

                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Text(
                    " Name:  ${user.username}",
                    style: AppStyles.appTextHeading(
                        AppColors.Black, FontWeight.w300),
                  ),

                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          child: SizedBox(
                            height: SizeConfig.safeBlockVertical*1,
                            child: new AlertDialog(
                              title: new Text("Edit Username", style: AppStyles.appTextHeading(
                                  AppColors.Black, FontWeight.w300),),
                              content: TextFormField(
                                onChanged: (val) {
                                  setState(() {
                                    username = val;
                                  });
                                },
                                validator: (val) =>
                                    val.isEmpty ? 'Enter new username' : null,
                                decoration: InputDecoration(
                                    hintText: 'Enter new username'),
                              ),
                              actions: [
                                FlatButton(
                                  child: Text('Update', style: AppStyles.appTextHeading(
                                      AppColors.Yellow, FontWeight.w300),),
                                  onPressed: () async {
                                   await _db.updateUsername(
                                        AuthService().getCurrentUserID(),
                                        username);

                                   Fluttertoast.showToast(
                                     msg: "Updated",
                                     toastLength: Toast.LENGTH_SHORT,
                                     gravity: ToastGravity.CENTER,
                                       backgroundColor: AppColors.Yellow,
                                       textColor: AppColors.White
                                   );
                                   setState(() {});
                                   Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: AppColors.Yellow)),
                ]),
              ),
              SizedBox(
                height:  SizeConfig.safeBlockVertical*1,
              ),
              Center(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [


                  Text(
                    "Phone Number:  ${user.phone}",
                    style: AppStyles.appTextHeading(
                        AppColors.Black, FontWeight.w300),
                  ),

                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          child: SizedBox(
                            height:  SizeConfig.safeBlockVertical*1,
                            child: new AlertDialog(
                              title: new Text("Edit Phone Number", style: AppStyles.appTextHeading(
                                  AppColors.Black, FontWeight.w300),),
                              content: TextFormField(
                                onChanged: (val) {
                                  setState(() {
                                    phone = val;
                                  });
                                },
                                validator: (val) => val.length < 10
                                    ? 'Please enter a valid 10 digit phone number'
                                    : null,
                                decoration:
                                    InputDecoration(hintText: 'Enter new phone'),
                              ),
                              actions: [
                                FlatButton(
                                  child: Text('Update', style: AppStyles.appTextHeading(
                                      AppColors.Yellow, FontWeight.w300),),
                                  onPressed: () async {
                                    if (phone.length != 10) {
                                      Fluttertoast.showToast(
                                        msg: "Enter a valid phone number (length 10)",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      await _db.updatePhone(
                                          AuthService().getCurrentUserID(), phone);
                                      Fluttertoast.showToast(
                                        msg: "Updated",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: AppColors.Yellow,
                                        textColor: AppColors.White
                                      );
                                      setState(() {});
                                      Navigator.pop(context);
                                    }

                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: AppColors.Yellow)),
                ]),
              ),

            ]),
          );
        } else if (snapshot.hasError) {
          return Text("Your Home");
        } else {
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: AppColors.Yellow,
                valueColor:
                    new AlwaysStoppedAnimation<Color>(AppColors.lipstick)),
          );
        }
      },
    );
    ;
  }
}
