import 'package:cloud_firestore/cloud_firestore.dart';

import '../Custom/Items.dart';
import '../Custom/Users.dart';

///class to handle shopping cart and making purchases
class ShoppingCartFirebase {

  ///add an item to cart
  addItemToCart(Users users, Item item) {



    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('cart')
        .doc(item.itemID).withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());


    if(item.amountInCart != null){
      item.amountInCart = item.amountInCart! + 1;
    }else{
      item.amountInCart = 1;
    }

    docRef.set(item);

  }

  ///remove item from cart
  deleteItemFromCart(Users users, Item item) {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('cart')
        .doc(item.itemID);

    docRef.delete();
  }

  double cartTotal = 0.00;
  ///get total for cart
  Future<double> getTotalForCart(Users users) async {

    cartTotal = 0.00;     //reset total to zero

    //create reference to client' cart
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('cart').withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());

    //get reference documents and get all totals
    await docRef.get().then((value) async => {

      for(var docSnap in value.docs){   //iterate through each document
        if(docSnap.data().onSale){    //if item is on sale, add sale price, else add regular retail price

          cartTotal += (docSnap.data().salePrice!.toDouble()) * docSnap.data().amountInCart!,
          print("${cartTotal}"),
        }else{
          cartTotal += (docSnap.data().retail)* docSnap.data().amountInCart!
        }
      }
    });
    final clientRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id).withConverter(
        fromFirestore: Users.fromFireStore,
        toFirestore: (Users users, options) => users.toFireStore());

    await clientRef.update({'cartTotal':cartTotal});



    print("In shopping cart total: $cartTotal");
    return cartTotal;

  }


  additionToItemInCart(Users users, Item item) async {
    // item.amountInCart = item.amountInCart?? 0 + 1;



    //create reference to client' cart
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('cart').doc(item.itemID).withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());


    if (item.amountInCart != null){
      await docRef.update({"amountInCart": item.amountInCart});
    }else{
      item.amountInCart =1;
      docRef.set(item);
    }



    //docRef.update({'amountInCart':item.amountInCart});
  }

  subtractionToItemInCart(Users users, Item item){

    //create reference to client' cart
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('cart').doc(item.itemID).withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) =>
            item.toFireStore());

    if(item.amountInCart! <= 0){
      docRef.delete();
    }else{
      docRef.update({'amountInCart':item.amountInCart});
    }

    this.getTotalForCart(users);


  }


  ///empty shopping cart
  clearShoppingCart(Users users){
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('cart');

    var newRef;

    final docSnap = docRef.get();

    docSnap.then((value) => {
      for(var docSnapShot in value.docs){

        newRef = FirebaseFirestore.instance
            .collection('users')
            .doc(users.id)
            .collection('cart')
            .doc(docSnapShot.id).delete(),

      }
    });
  }
}
