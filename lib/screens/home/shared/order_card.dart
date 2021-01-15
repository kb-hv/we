import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we/models/order.dart';
import 'package:we/screens/home/shared/order_details.dart';
import 'package:we/services/database.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/Styles/decoration.dart';
import 'package:we/shared/loading.dart';
import 'package:we/shared/size_config.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  OrderCard({this.order});
  String orderName = "";
  final DatabaseService _db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    bool isUserAdmin = Provider.of<bool>(context);
    return isUserAdmin == null
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical*0.2, horizontal: SizeConfig.safeBlockHorizontal*1),
      child: Card(
              //
              // shape: RoundedRectangleBorder(
              //   side: BorderSide(color: AppColors.Yellow, width: 1),
              //   borderRadius: BorderRadius.circular(20),
              // ),
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    //right: BorderSide(color: AppColors.Yellow),
                    bottom: BorderSide(width: 0,color: AppColors.Yellow),
                  ),
                ),
                //
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FutureProvider<List<Item>>.value(
                                  value: _db.getItems(order.docID),
                                  child: OrderDetails(
                                    order: order,
                                    isUserAdmin: isUserAdmin,
                                  ),
                                )));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical*2, horizontal: SizeConfig.safeBlockHorizontal*1),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            order.orderName.length > 14
                                ? Text(
                                    order.orderName.substring(0, 14) + "...",
                                    style: AppStyles.appTextHeading(
                                        AppColors.Black, FontWeight.w300),
                                  )
                                : Text(
                                    order.orderName,
                                    style: AppStyles.appTextHeading(
                                        AppColors.Black, FontWeight.w300),
                                  ),
                            Text(order.sellerName,
                                style:
                                    AppStyles.appTextRegular(AppColors.Black))
                          ],
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.fromLTRB(SizeConfig.safeBlockVertical*2, 0, SizeConfig.safeBlockVertical*2, SizeConfig.safeBlockVertical*2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order.customerName,
                                style:
                                    AppStyles.appTextRegular(AppColors.Black)),
                            Text(
                                "${DateTime.parse(order.date.toString()).day}/${DateTime.parse(order.date.toString()).month}/${DateTime.parse(order.date.toString()).year}",
                                style:
                                    AppStyles.appTextRegular(AppColors.Black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
