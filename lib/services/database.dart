import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:we/models/order.dart';
import 'package:we/models/user.dart';
import 'package:we/services/authenticate.dart';

class DatabaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  AuthService _authService = AuthService();

  Future<void> createUserData(
      String uid, String username, String email, String phone) async {
    return await _firebaseFirestore.collection("users").doc(uid).set({
      'uid': uid,
      'username': username,
      'email': email,
      'phone': phone,
      'isAdmin': false
    });
  }

  Future<void> updateUsername(String uid, String username) async {
    return await _firebaseFirestore.collection("users").doc(uid).update({
      'username': username,
    });
  }

  Future<void> updatePhone(String uid, String phone) async {
    return await _firebaseFirestore.collection("users").doc(uid).update({
      'phone': phone,
    });
  }

  Future<void> deleteOrder(String docID) {
    _firebaseFirestore
        .collection("orders")
        .doc(docID)
        .collection("items")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    _firebaseFirestore.collection("orders").doc(docID).delete();
  }

  Future<void> changeOrderStatus(String uid, bool value) async {
    return await _firebaseFirestore
        .collection("orders")
        .doc(uid)
        .update({'isCompleted': value, 'completedDateTime': DateTime.now()});
  }

  Future<bool> isUserAdmin() async {
    var document = await _firebaseFirestore
        .collection('users')
        .doc(_authService.getCurrentUserID())
        .get();
    return document.get('isAdmin');
  }

  Future<UserModel> getCurrentUserModel() async {
    DocumentSnapshot documentSnapshot = await _firebaseFirestore
        .collection("users")
        .doc(_authService.getCurrentUserID().toString())
        .get();
    print(documentSnapshot.get('username'));
    return UserModel(
      username: documentSnapshot.get('username').toString(),
      uid: documentSnapshot.id,
      phone: documentSnapshot.get('phone'),
      email: documentSnapshot.get('email'),
    );
  }

  //non admin users
  Future<List<UserModel>> getUsers() async {
    QuerySnapshot qShot = await _firebaseFirestore
        .collection("users")
        .where('isAdmin', isEqualTo: false)
        .get();
    return qShot.docs
        .map((doc) => UserModel(username: doc.data()['username'], uid: doc.id))
        .toList();
  }

  //add new order
  Future addOrder(Order order) async {
    DocumentReference documentReference = await _firebaseFirestore
        .collection("orders")
        .add(_convertOrderToMap(order));
    await _firebaseFirestore
        .collection('orders')
        .doc(documentReference.id)
        .update({'orderID': documentReference.id});
    //subcollection
    order.items.forEach((Item item) async {
      await _firebaseFirestore
          .collection("orders")
          .doc(documentReference.id)
          .collection("items")
          .add(_convertItemToMap(item));
    });
  }

  //convert Order instance to map so it can be added to collection 'orders'
  Map<String, dynamic> _convertOrderToMap(Order order) {
    Map<String, dynamic> map = {};
    map['customerName'] = order.customerName;
    map['customerPhone'] = order.customerPhone;
    map['customerAddress'] = order.customerAddress;
    map['sellerID'] = order.sellerID;
    map['sellerName'] = order.sellerName;
    map['isCompleted'] = false;
    map['orderName'] = order.orderName;
    map['datetime'] = order.date;
    map['completedDateTime'] = null;
    return map;
  }

  Map<String, dynamic> _convertItemToMap(Item item) {
    Map<String, dynamic> map = {};
    map['itemName'] = item.itemName;
    map['itemQuantity'] = item.itemQuantity;
    map['costPerItem'] = item.costPerItem;
    return map;
  }

  Stream<List<Order>> get sellerInactiveOrders {

  }

  Stream<List<Order>> get sellerActiveOrders {
    return _firebaseFirestore
        .collection("orders")
        .where('isCompleted', isEqualTo: false)
        .where('sellerID', isEqualTo: _authService.getCurrentUserID())
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) =>
                mapDocumentSnapshotToOrder(documentSnapshot))
            .toList());
  }

  Order mapDocumentSnapshotToOrder(DocumentSnapshot documentSnapshot) {
    Order order = Order(
        docID: documentSnapshot.id,
        orderName: documentSnapshot.data()['orderName'],
        customerName: documentSnapshot.data()['customerName'],
        customerPhone: documentSnapshot.data()['customerPhone'],
        customerAddress: documentSnapshot.data()['customerAddress'],
        sellerName: documentSnapshot.data()['sellerName'],
        sellerID: documentSnapshot.data()['sellerID'],
        date: documentSnapshot.data()['datetime'].toDate(),
        isCompleted: documentSnapshot.data()['isCompleted'],
        orderID: documentSnapshot.data()['orderID']);
    if (order.isCompleted) {
      order.completedDateTime =
          documentSnapshot.data()['completedDateTime'].toDate();
    }
    return order;
  }

  Future<List<Item>> getItems(String docID) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("orders")
        .doc(docID)
        .collection("items")
        .get();

    return querySnapshot.docs
        .map((doc) => Item(
            itemName: doc.data()['itemName'],
            itemQuantity: doc.data()['itemQuantity'],
            costPerItem: doc.data()['costPerItem']))
        .toList();
  }

  List<Order> activeOrders = [];
  bool isActiveLoading = false;
  bool hasMoreActive = true;
  int documentLimit = 6;
  DocumentSnapshot lastActive;

  Future getActive() async {
    if (!hasMoreActive) return;
    if (isActiveLoading) return;
    isActiveLoading = true;
    QuerySnapshot querySnapshot;
    if (lastActive == null) {
      querySnapshot = await _firebaseFirestore
          .collection("orders")
          .where('isCompleted', isEqualTo: false)
          .orderBy('datetime', descending: true)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await _firebaseFirestore
          .collection("orders")
          .where('isCompleted', isEqualTo: false)
          .orderBy('datetime', descending: true)
          .startAfterDocument(lastActive)
          .limit(documentLimit)
          .get();
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMoreActive = false;
    }
    lastActive = querySnapshot.docs.last;
    activeOrders.addAll(querySnapshot.docs
        .map((DocumentSnapshot documentSnapshot) =>
            mapDocumentSnapshotToOrder(documentSnapshot))
        .toList());
    isActiveLoading = false;
    return activeOrders;
  }

  Future<List<Order>> allOrders(bool isCompleted) async {
    dynamic qs = await _firebaseFirestore
        .collection('orders')
        .where('isCompleted', isEqualTo: isCompleted)
        .orderBy('datetime', descending: false)
        .limit(10)
        .get();
    return qs.docs
        .map<Order>((DocumentSnapshot documentSnapshot) =>
            mapDocumentSnapshotToOrder(documentSnapshot))
        .toList();
  }
  Future<List<Order>> allOrdersMore(bool isCompleted, String orderID) async {
    DocumentSnapshot ds = await docSnapshot(orderID);
    dynamic qs = await _firebaseFirestore
        .collection('orders')
        .where('isCompleted', isEqualTo: isCompleted)
        .orderBy('datetime', descending: true)
        .startAfterDocument(ds)
        .limit(10)
        .get();
    return qs.docs
        .map<Order>((DocumentSnapshot documentSnapshot) =>
            mapDocumentSnapshotToOrder(documentSnapshot))
        .toList();
  }

  Future<List<Order>> selectOrders(bool isCompleted) async {
    dynamic qs = await _firebaseFirestore
        .collection('orders')
        .where('sellerID', isEqualTo: _authService.getCurrentUserID())
        .where('isCompleted', isEqualTo: isCompleted)
        .orderBy('datetime', descending: false)
        .limit(10)
        .get();
    return qs.docs
        .map<Order>((DocumentSnapshot documentSnapshot) =>
        mapDocumentSnapshotToOrder(documentSnapshot))
        .toList();
  }
  Future<List<Order>> selectOrdersMore(bool isCompleted, String orderID) async {
    DocumentSnapshot ds = await docSnapshot(orderID);
    dynamic qs = await _firebaseFirestore
        .collection('orders')
        .where('sellerID', isEqualTo: _authService.getCurrentUserID())
        .where('isCompleted', isEqualTo: isCompleted)
        .orderBy('datetime', descending: true)
        .startAfterDocument(ds)
        .limit(10)
        .get();
    return qs.docs
        .map<Order>((DocumentSnapshot documentSnapshot) =>
        mapDocumentSnapshotToOrder(documentSnapshot))
        .toList();
  }

  Future<DocumentSnapshot> docSnapshot(String orderID) {
    return _firebaseFirestore.collection('orders').doc(orderID).get();
  }
}
