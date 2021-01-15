class Order {
  final DateTime date;
  final String docID;
  final String orderName;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String sellerID;
  final String sellerName;
  DateTime completedDateTime;
  bool isCompleted;
  List<Item> items;
  String orderID;

  Order({this.orderID, this.isCompleted, this.docID, this.orderName, this.customerPhone, this.customerAddress, this.customerName, this.sellerID, this.sellerName, this.date, this.items, this.completedDateTime});
}

class Item {
  final String itemName;
  final int costPerItem;
  final int itemQuantity;

  Item({this.itemName, this.costPerItem, this.itemQuantity});
}