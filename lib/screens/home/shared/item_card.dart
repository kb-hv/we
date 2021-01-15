import 'package:flutter/material.dart';
import 'package:we/models/order.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/Styles/decoration.dart';
import 'package:we/shared/size_config.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  ItemCard({this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          border: Border(
            // top: BorderSide(width: 1.0, color: AppColors.Yellow),
            // bottom: BorderSide(width: 1.0, color: AppColors.Yellow),
          ),
          color: AppColors.White),
      child: ExpansionTile(
        backgroundColor: AppColors.White,
       // childrenPadding: EdgeInsets.all(10),
        title: Text('Item: ${item.itemName}',
            style: AppStyles.appTextRegular(AppColors.Black)),
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.safeBlockVertical*1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Quantity: ${item.itemQuantity}',
                  style: AppStyles.appTextRegular(AppColors.Black),
                ),
                Text(
                  'Cost per item: ${item.costPerItem}',
                  style: AppStyles.appTextRegular(AppColors.Black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
