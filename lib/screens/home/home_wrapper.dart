import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we/screens/home/admin_view/admin_home.dart';
import 'package:we/screens/home/seller_view/seller_home.dart';
import 'package:we/services/database.dart';
import 'package:we/shared/loading.dart';

class HomeWrapper extends StatelessWidget {
  DatabaseService _db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    bool isUserAdmin = Provider.of<bool>(context);
    if (isUserAdmin == null)
      {
        print("loading");
        return Loading();
      }

    return isUserAdmin ? AdminHome() : SellerHome();
    // return FutureBuilder<bool>(
    //   future: _db.isUserAdmin(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError)
    //       return AuthWrapper();
    //     else if (snapshot.hasData)
    //       return snapshot.data ? AdminHome() : SellerHome();
    //     else
    //       return Loading();
    //   },
    // );
  }
}
