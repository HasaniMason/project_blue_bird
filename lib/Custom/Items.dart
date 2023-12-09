import 'package:cloud_firestore/cloud_firestore.dart';




class Item{

  String itemName;
  double retail;
  String itemID;
  String itemDescription;

  int amountAvailable;
  bool onSale;
  double? salePrice;


  double? cost;
  String? picLocation;

  int? amountInCart;


  Item({required this.itemName, required this.retail, required this.itemID, required this.itemDescription,
    required this.amountAvailable, required this.onSale, this.cost, this.picLocation, this.salePrice, this.amountInCart});


  factory Item.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options){
    final data = snapshot.data();
    return Item(itemName: data?['itemName'],
        retail: data?['retail'],
        itemID: data?['itemID'],
        itemDescription: data?['itemDescription'],
        amountAvailable: data?['amountAvailable'],
        onSale: data?['onSale'],
        cost: data?['cost'],
        picLocation: data?['picLocation'],
        salePrice: data?['salePrice'],
        amountInCart: data?['amountInCart']);
  }

  Map<String, dynamic> toFireStore(){
    return{
      'itemName':itemName,
      'retail':retail,
      'itemID':itemID,
      'itemDescription': itemDescription,
      'amountAvailable': amountAvailable,
      'onSale': onSale,
      'cost': cost,
      'picLocation': picLocation,
      'salePrice':salePrice,
      'amountInCart':amountInCart
    };
  }


}