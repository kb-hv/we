import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we/models/order.dart';
import 'package:we/screens/home/shared/order_card.dart';
import 'package:we/services/database.dart';
import 'package:we/shared/Styles/colors.dart';
import 'package:we/shared/loading.dart';
import 'package:we/shared/size_config.dart';

class AdminActiveOrders extends StatefulWidget {
  @override
  _AdminActiveOrdersState createState() => _AdminActiveOrdersState();
}

class _AdminActiveOrdersState extends State<AdminActiveOrders> {
  DatabaseService _db = DatabaseService();
  List<Order> orders = [];
  Order lastOrder;
  bool isLoading = false;
  bool hasMore = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getOrders();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getOrders();
      }
    });
  }

  getOrders() async {
    if (!hasMore) {
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    if (lastOrder == null) {
      orders = await _db.allOrders(false);
    } else {
      List<Order> temp = await _db.allOrdersMore(false, orders.last.orderID);
      orders.addAll(temp);
      if (temp.length < 10) {
        hasMore = false;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.White,

      body: Column(children: [
        Expanded(
          child: orders.length == 0
              ? Center(
                  child: Text('No Active Orders'),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return OrderCard(order: orders[index]);
                    // order: _db.mapDocumentSnapshotToOrder(orders[index]));
                  },
                ),
        ),
        isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal*1),
                child: Loading(),
              )
            : Container()
      ]),
      // floatingActionButton: FloatingActionButton(
      //   elevation: 2,
      //   child: Icon(Icons.add),
      //   // backgroundColor: AppColors.whitebackground,
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => NewOrderForm()));
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
