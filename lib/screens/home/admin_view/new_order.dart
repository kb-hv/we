import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we/models/order.dart';
import 'package:we/models/user.dart';
import 'package:we/services/database.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/Styles/decoration.dart';
import 'package:we/shared/loading.dart';

class NewOrderForm extends StatefulWidget {
  @override
  _NewOrderFormState createState() => _NewOrderFormState();
}

class _NewOrderFormState extends State<NewOrderForm> {

  DatabaseService _db = DatabaseService();
  String sellerError = "";
  String error = "";
  String orderName;
  String customerName;
  String customerPhone;
  String customerAddress;
  String dropDownValue = "pick a seller";

  List<Item> items = List();
  //temp item values
  String itemName;
  int itemQuantity;
  int costPerItem;

  int selectedUserNumber;
  UserModel selectedUser;
  final _formKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20,70,20,0),
          child: Container(
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
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 0,),
                  Text(
                    'New Order',
                      style: AppStyles.appTextHeading2(AppColors.Black,FontWeight.w200)
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    onChanged: (val) {
                      orderName = val;
                    },
                    validator: (val) => val.isEmpty ? "Enter Order Name" : null,
                    decoration: InputDecoration(hintText: 'Order Name', hintStyle: AppStyles.appTextRegular(AppColors.suggestionGrey)),
                  ),
                  SizedBox(height: 20,),
                  FutureBuilder<List<UserModel>>(
                    future: _db.getUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DropdownMenuItem> currentUsers = [];
                        for (int i = 0; i < snapshot.data.length; i++) {
                          UserModel userModel = snapshot.data[i];
                          currentUsers.add(
                            DropdownMenuItem(
                              child: Text(userModel.username, style: AppStyles.appTextRegular(AppColors.Black)),
                              value: i,
                            )
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton(
                              iconEnabledColor: AppColors.Yellow,

                              items: currentUsers,
                              onChanged: (val) {
                                setState(() {
                                  selectedUser = snapshot.data[val];
                                  selectedUserNumber = val;
                                });
                              },
                              value: selectedUserNumber,
                              hint: Text('  Assign order to', style: AppStyles.appTextRegular(AppColors.Black))
                            ),
                            Text(sellerError, style: TextStyle(color: Colors.red))
                          ],
                        );
                      }
                      else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('assign order to:',style: AppStyles.appTextRegular(AppColors.Black)),
                          Text(sellerError,style: AppStyles.appTextRegular(AppColors.Black))
                        ]

                      );
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    onChanged: (val) {
                      customerName = val;
                    },
                    validator: (val) => val.isEmpty ? "Enter customer's Name" : null,
                    decoration: InputDecoration (hintText: 'Customer Name', hintStyle: AppStyles.appTextRegular(AppColors.suggestionGrey)),
                  ),

                  SizedBox(height: 20,),

                  TextFormField(
                    onChanged: (val) {
                      customerPhone = val;
                    },

                    validator: (val) => val.length != 10 ? "Enter customer's Phone Number" : null,
                    decoration: InputDecoration(hintText: 'Customer Phone',hintStyle: AppStyles.appTextRegular(AppColors.suggestionGrey)),
                  ),

                  SizedBox(height: 20,),

                  TextFormField(
                    onChanged: (val) {
                      customerAddress = val;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    validator: (val) => val.isEmpty ? "Enter customer's Address" : null,
                    decoration: InputDecoration(hintText: 'Customer Address',hintStyle: AppStyles.appTextRegular(AppColors.suggestionGrey)),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        color: AppColors.Yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),

                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                  child: AlertDialog(
                                    title: Text("Item Details",style: AppStyles.appTextHeading(AppColors.Black,FontWeight.normal)),
                                    elevation: 24.0,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Form(
                                          key: _itemFormKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    itemName = val;
                                                  });
                                                },
                                                validator: (val) => val.isEmpty ? "enter item name" : null,
                                                decoration: InputDecoration(hintText: "Item name",hintStyle: AppStyles.appTextRegular(AppColors.suggestionGrey)),
                                              ),
                                              SizedBox(height: 20,),
                                              TextFormField(
                                                onChanged: (val) {
                                                  itemQuantity = int.parse(val);
                                                },
                                                keyboardType: TextInputType.number,
                                                validator: (val) => val.isEmpty ? "enter quantity" : null,
                                                decoration: InputDecoration(hintText: "Quantity",hintStyle: AppStyles.appTextRegular(AppColors.suggestionGrey)),
                                              ),
                                              SizedBox(height: 20,),
                                              TextFormField(
                                                onChanged: (val) {
                                                  costPerItem = int.parse(val);
                                                },
                                                keyboardType: TextInputType.number,
                                                validator: (val) => val.isEmpty ? "enter cost per item" : null,
                                                decoration: InputDecoration(hintText: "Cost per item",hintStyle: AppStyles.appTextRegular(AppColors.suggestionGrey)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      FlatButton(

                                          onPressed: () {
                                            if(_itemFormKey.currentState.validate()) {
                                              setState(() {
                                                Item item = Item(itemQuantity: itemQuantity, itemName: itemName, costPerItem: costPerItem);
                                                items.add(item);
                                                //items.forEach((element) {print(item.itemName);});
                                              });
                                              Fluttertoast.showToast(
                                                msg: "Item added",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                              Navigator.pop(context);


                                             // print(items.length);
                                            }
                                          },
                                          child: Text("Add",style: AppStyles.appTextHeading(AppColors.lipstick,FontWeight.normal))
                                      )
                                    ],
                                  ),
                                );
                              }
                          );
                        },

                        child: Padding(
                          padding: EdgeInsets.all(3),
                            child: Text("Add an item",style: AppStyles.appTextRegular(AppColors.White))),
                      ),
                      Text("No. of items added: ${items.length}", style: AppStyles.appTextRegular(AppColors.Black),),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(error, style : TextStyle(color: Colors.red)),
                  SizedBox(height: 20,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),

                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                        child: Text('Create Order',style: AppStyles.appTextHeading(AppColors.White,FontWeight.w300))),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        if(items.length > 0 && selectedUser != null) {
                          setState(() {
                            sellerError = "";
                            error = "";
                            loading = true;
                          });
                          Order order = Order(date: DateTime.now(), orderName: orderName, customerAddress: customerAddress, customerPhone: customerPhone, customerName: customerName,sellerID: selectedUser.uid, sellerName: selectedUser.username);
                          order.items = items;
                          await _db.addOrder(order);
                          Fluttertoast.showToast(
                            msg: "Order Created",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            sellerError = selectedUser == null? "select." : "";
                            error = items.length < 1? "add atleast one item": "";
                          });
                        }
                      }
                    },
                    color: AppColors.Yellow,
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
