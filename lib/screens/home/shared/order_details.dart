import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we/models/order.dart';
import 'package:we/screens/home/shared/item_card.dart';
import 'package:we/services/database.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/Styles/decoration.dart';
import 'package:we/shared/loading.dart';
import 'package:we/shared/size_config.dart';

class OrderDetails extends StatefulWidget {
  Order order;
  bool isUserAdmin;
  OrderDetails({this.order, this.isUserAdmin});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  DatabaseService _db = DatabaseService();
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    List<Item> items = Provider.of<List<Item>>(context);
    if (items == null) return Loading();
    return Scaffold(
      backgroundColor: AppColors.White,
      appBar: AppBar(
          leading: BackButton(color: AppColors.White),
          centerTitle: true,
          title: Text(widget.order.orderName,
              style:
                  AppStyles.appTextHeading(AppColors.White, FontWeight.w400)),
          elevation: 0.0,
          actions: [
            widget.isUserAdmin == null
                ? Container()
                : widget.isUserAdmin
                    ? Padding(
                        padding:  EdgeInsets.only(right: SizeConfig.safeBlockVertical*1),
                        child: IconButton(
                          icon: AppStyles.iconStyling(
                              Icons.delete, AppColors.White),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Are you sure?",
                                        style: AppStyles.appTextHeading(
                                            AppColors.Black, FontWeight.w300)),
                                    content: Text(
                                        "You will not be able to undo this."),
                                    actions: [
                                      FlatButton(
                                        child: Text("Yes, delete.",style: AppStyles.appTextRegular(
                                            AppColors.Yellow,)),
                                        onPressed: () {
                                          _db.deleteOrder(widget.order.docID);
                                          Fluttertoast.showToast(
                                            msg: "Order Deleted.",
                                            backgroundColor: Colors.black45,
                                            textColor: Colors.white,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Don't delete",style: AppStyles.appTextRegular(
                                          AppColors.Yellow,)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                        ),
                      )
                    : Container()
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom:SizeConfig.safeBlockVertical*2),
          child: Column(children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical*2,
            ),
            Container(
              padding: EdgeInsets.all(SizeConfig.safeBlockVertical*3),
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date Created: ",
                            style: AppStyles.appTextRegular(AppColors.Black)),
                        Text(
                            "${DateTime.parse(widget.order.date.toString()).day}/${DateTime.parse(widget.order.date.toString()).month}/${DateTime.parse(widget.order.date.toString()).year}",
                            style: AppStyles.appTextRegular(AppColors.Black))
                      ]),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical*1,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Assigned to: ",
                            style: AppStyles.appTextRegular(AppColors.Black)),
                        Text(widget.order.sellerName,
                            style: AppStyles.appTextRegular(AppColors.Black))
                      ]),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical*1,
            ),
            widget.order.completedDateTime != null
                ? Padding(
              padding: EdgeInsets.all(SizeConfig.safeBlockVertical*3),
              child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Text("Date Completed: ",
                              style: AppStyles.appTextRegular(AppColors.Black)),
                          Text(
                              "${DateTime.parse(widget.order.completedDateTime.toString()).day}/${DateTime.parse(widget.order.completedDateTime.toString()).month}/${DateTime.parse(widget.order.completedDateTime.toString()).year}",
                              style: AppStyles.appTextRegular(AppColors.Black))
                        ]),
                )
                : Container(),
            SizedBox(
              height: SizeConfig.safeBlockVertical*1,
            ),
            Container(
              padding: EdgeInsets.all(SizeConfig.safeBlockVertical*3),
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
                  Text("CUSTOMER DETAILS",
                      style: AppStyles.appTextHeading(
                          AppColors.Black, FontWeight.w300)),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical*1,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Name: ",
                            style: AppStyles.appTextRegular(AppColors.Black)),
                        Text(widget.order.customerName,
                            style: AppStyles.appTextRegular(AppColors.Black))
                      ]),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical*1,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Phone: ",
                            style: AppStyles.appTextRegular(AppColors.Black)),
                        InkWell(
                            onTap: () async {
                              String phone =
                                  "tel: +91" + widget.order.customerPhone;
                              if (await canLaunch(phone)) {
                                await launch(phone);
                              } else {}
                            },
                            child: Text(widget.order.customerPhone,
                                style: AppStyles.appTextRegular(
                                    AppColors.Yellow)))
                      ]),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical*1,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Address: ",
                            style: AppStyles.appTextRegular(AppColors.Black)),
                      ]),
                  Container(
                      padding: EdgeInsets.all(SizeConfig.safeBlockVertical*1),
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical*2, bottom: SizeConfig.safeBlockVertical*2),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.suggestionGrey)),
                      child: Padding(
                        padding:  EdgeInsets.all(SizeConfig.safeBlockVertical*0.5),
                        child: SelectableText(widget.order.customerAddress,
                            style: AppStyles.appTextRegular(AppColors.Black)),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical*2,
            ),
            Container(
                padding: EdgeInsets.all(SizeConfig.safeBlockVertical*1),
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
                    Text("ITEMS",
                        style: AppStyles.appTextHeading(
                            AppColors.Black, FontWeight.w300)),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical*1,
                    ),
                    Container(
                      child: Column(
                        children: items
                            .map((item) => ItemCard(item: item))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical*2,
                    ),
                    widget.isUserAdmin == null
                        ? Container()
                        : widget.isUserAdmin
                            ? Container()
                            : widget.order.isCompleted
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Order Completed?",
                                            style: AppStyles.appTextRegular(
                                                AppColors.Black),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.safeBlockVertical*1,
                                          ),
                                          CupertinoSwitch(
                                            activeColor: AppColors.Yellow,
                                            value: _switchValue,
                                            onChanged: (value) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Are you sure?",
                                                          style: AppStyles
                                                              .appTextHeading(
                                                                  AppColors
                                                                      .Black,
                                                                  FontWeight
                                                                      .normal)),
                                                      content: Text(
                                                        "You will not be able to undo this. Click only if completed.",
                                                        style: AppStyles
                                                            .appTextRegular(
                                                                AppColors
                                                                    .Black),
                                                      ),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text(
                                                              "Yes, Completed",
                                                              style: AppStyles
                                                                  .appTextRegular(
                                                                      AppColors
                                                                          .Yellow)),
                                                          onPressed: () {
                                                            setState(() {
                                                              _switchValue =
                                                                  value;
                                                            });
                                                            _db.changeOrderStatus(
                                                                widget.order
                                                                    .docID,
                                                                value);
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Order Completed",
                                                              backgroundColor:
                                                                  AppColors
                                                                      .Yellow,
                                                              textColor:
                                                                  Colors
                                                                      .white,
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child: Text(
                                                            "No",
                                                            style: AppStyles
                                                                .appTextRegular(
                                                                    AppColors
                                                                        .Yellow),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
