import 'package:flutter/material.dart';
import 'package:we/models/user.dart';
import 'package:we/screens/home/admin_view/admin_active_orders.dart';
import 'package:we/screens/home/admin_view/admin_history.dart';
import 'package:we/screens/home/admin_view/new_order.dart';
import 'package:we/services/authenticate.dart';
import 'package:we/services/database.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/Styles/decoration.dart';
import 'package:we/screens/home/shared/edit_details.dart';
import 'package:we/shared/size_config.dart';

// TODO: Say hello, display current active orders in home

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  AuthService _auth = AuthService();

  String _appbarTitle = 'Admin Home';
  int _currentIndex = 0;
  final widgetList = [AdminHomeView(), AdminActiveOrders(), AdminHistory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appbarTitle,
          style: AppStyles.appTextHeading(AppColors.White, FontWeight.normal),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          FlatButton(
            onPressed: () {
              _auth.signOut();
            },
            child: AppStyles.iconStyling(Icons.exit_to_app, AppColors.White),
          )
        ],
      ),
      body: widgetList.elementAt(_currentIndex),
      bottomNavigationBar: Container(
        decoration: AppStyles.bottomNavBarStyling(),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  "",
                  style: TextStyle(fontSize: 0),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                title: Text(" ", style: TextStyle(fontSize: 0))),
            BottomNavigationBarItem(
                icon: Icon(Icons.history),
                title: Text("", style: TextStyle(fontSize: 0))),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 0) {
                _appbarTitle = 'Home';
              } else if (index == 1) {
                _appbarTitle = 'Active Orders';
              } else if (index == 2) {
                _appbarTitle = 'Order History';
              }
            });
          },
          fixedColor: AppColors.Yellow,
        ),
      ),
    );
  }
}

class AdminHomeView extends StatefulWidget {
  @override
  _AdminHomeViewState createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _db.getCurrentUserModel(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel user = snapshot.data;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/adminhome.png', height: 200, width: 200,),
                Text(
                  "Welcome, ${user.username}",
                  style: AppStyles.appTextRegular(AppColors.Black),
                ),
                Text(
                  user.email,
                  style: AppStyles.appTextRegular(AppColors.Black),
                ),
                Text(
                  user.phone,
                  style: AppStyles.appTextRegular(AppColors.Black),
                ),
                Container(
                  padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical*5),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*4),
                        child: Container(
                          height: SizeConfig.safeBlockVertical*20,
                          width: SizeConfig.safeBlockVertical*20,

                        child: SizedBox(
                          height: 50,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppColors.Yellow, width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            child: Text('New Order', style: AppStyles.appTextHeading(AppColors.White, FontWeight.w400),),
                            color: AppColors.Yellow,
                            onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrderForm()));
                    }
                    ),
                        ),),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*4),
                          child: Container(
                              child: Container(
                                height: SizeConfig.safeBlockVertical*20,
                                width: SizeConfig.safeBlockVertical*20,

                                child: SizedBox(
                              height: 50,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: AppColors.Yellow, width: 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('Edit Details', style: AppStyles.appTextHeading(AppColors.White, FontWeight.w400),),
                                  color: AppColors.Yellow,
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditDetails()))
                                        .then((value) => setState(() => {}));
                                  }),
                            ),
                          )
                      ),

                      ),
                  ]),

                ),]
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Admin Home");
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
  }
}
