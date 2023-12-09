import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../Custom/Items.dart';
import '../Custom/ShopOrders.dart';
import '../Custom/Users.dart';
import 'ShoppingCartFirebase.dart';
import 'dart:io';

class ShopOrdersFirebase {


  Future createOrderFromCart(Users users) async {
    var v4 = Uuid();
    var id = v4.v4();
    ShoppingCartFirebase shoppingCartFirebase = ShoppingCartFirebase();

    ShopOrders shopOrders = await ShopOrders(total: users.cartTotal!,
        streetAddress: users.addressLine1 ?? "",
        streetAddressContinued: users.addressLine2 ?? "",
        zipCode: users.zipCode ?? "",
        city: users.city ?? "",
        state: users.state ?? "",
        id: id,
        firstName: users.firstName,
        lastName: users.lastName,
        phoneNumber: users.phoneNumber,
        clientId: users.id,
        email: users.email,
        date: DateTime.now(),
    customOrder: false,
    orderComplete: false,
    orderApproved: false);

    //get shopping cart ref
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('cart').withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());

    //set initial shop order info
    var startRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(id).withConverter(
        fromFirestore: ShopOrders.fromFireStore,
        toFirestore: (ShopOrders shopOrders, options) =>
            shopOrders.toFireStore());

    startRef.set(shopOrders);

    //ref for order
    var orderRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(id).collection('items').withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());

    //add each item to order ref
    final docSnap = docRef.get().then((value) =>
    {
      for(var snap in value.docs){

        orderRef.add(snap.data())
      }
    });



    //clear cart
    shoppingCartFirebase.clearShoppingCart(users);

    final resetRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id);

    resetRef.update({'cartTotal': 0});
  }

  Future addCustomOrderForReview(Users users, String description, String picLocation) async {

    var v4 = Uuid();
    var id = v4.v4();

    var itemId = v4.v4();
    ShopOrders shopOrders = await ShopOrders(total: 0.00,
        streetAddress: users.addressLine1 ?? "",
        streetAddressContinued: users.addressLine2 ?? "",
        zipCode: users.zipCode ?? "",
        city: users.city ?? "",
        state: users.state ?? "",
        id: id,
        firstName: users.firstName,
        lastName: users.lastName,
        phoneNumber: users.phoneNumber,
        clientId: users.id,
        email: users.email,
        date: DateTime.now(),
        customOrder: true,
    orderComplete: false,
    picLocation:'Hummingbird/images/customOrder/customOrder$itemId.jpg',
    orderApproved: false);

    var startRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(id).withConverter(
        fromFirestore: ShopOrders.fromFireStore,
        toFirestore: (ShopOrders shopOrders, options) =>
            shopOrders.toFireStore());

    startRef.set(shopOrders);



    Item customItem = Item(itemName: "Custom Item", retail: 0.00, itemID: itemId, itemDescription: description, amountAvailable: 1, onSale: false,picLocation: 'Hummingbird/images/customOrder/customOrder$itemId.jpg');

    var orderRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(id).collection('items').withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());


    orderRef.add(customItem);

    uploadOrderPic(picLocation, customItem);


  }

  uploadOrderPic(String path, Item item) async {
    final storageRef = FirebaseStorage.instance.ref();

    final refString =
        'Hummingbird/images/customOrder/customOrder${item.itemID}.jpg';

    final imageRef = storageRef.child(refString);
    //final socialImagesRef = storageRef.child('images/$refString.jpg');

    // assert(socialRef.name == socialImagesRef.name);
    // assert(socialRef.fullPath != socialImagesRef.fullPath);

    File file = File(path);

    try {
      await imageRef.putFile(file);
    } on FirebaseException catch (e) {
      print("Picture Error: $e");
    }
  }

  createCustomOrder(Users users, num total, Item customItem) async {

    var v4 = Uuid();
    var id = v4.v4();

    //create order variable
    ShopOrders shopOrders = await ShopOrders(total: total,
        streetAddress: users.addressLine1 ?? "",
        streetAddressContinued: users.addressLine2 ?? "",
        zipCode: users.zipCode ?? "",
        city: users.city ?? "",
        state: users.state ?? "",
        id: id,
        firstName: users.firstName,
        lastName: users.lastName,
        phoneNumber: users.phoneNumber,
        clientId: users.id,
        email: users.email,
        date: DateTime.now(),
        customOrder: true,
    orderComplete: false,
    orderApproved: false);


    //set initial shopOrder details
    var startRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(id).withConverter(
        fromFirestore: ShopOrders.fromFireStore,
        toFirestore: (ShopOrders shopOrders, options) =>
            shopOrders.toFireStore());

    startRef.set(shopOrders);


    //set custom item into order
    var orderRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(id).collection('items').withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());


    orderRef.add(customItem);
  }


  updatePriceForCustomOrder(ShopOrders shopOrders,String price){
    var startRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(shopOrders.id);


    startRef.update({'total':double.parse(price)});
    startRef.update({'orderApproved':true});


  }

  deleteOrder(ShopOrders shopOrders){
    var startRef = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(shopOrders.id);
    startRef.delete();
  }

}