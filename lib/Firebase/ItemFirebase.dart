import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../Custom/Items.dart';

class ItemFirebase {
  updateItemInCatalog(Item item) async {
    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());
  }

  List<Item> itemCatalog = [];

  Future<List<Item>> getItemCatalog() async {
    itemCatalog.clear();

    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());

    await docRef.get().then((value) => {
      for (var docSnapshot in value.docs)
        {itemCatalog.add(docSnapshot.data())}
    });

    return itemCatalog;
  }

  addItemToCatalog(Item item, String? path) {
    var uuid = Uuid();
    item.itemID = uuid.v4();

    //if it has a picture, upload to storage
    if (path != null) {
      uploadPic(path, item); //created function to upload pic to database
      item.picLocation =
      'Hummingbird/images/itemCatalog/itemCatalog${item.itemID}.jpg'; //store path to database in variable to reference later
    }

    //create ref for catalog
    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());

    //store item
    docRef.set(item);
  }


  editItemInCatalog(Item item, String? path){



    if (path != null) {
      uploadPic(path, item); //created function to upload pic to database
      item.picLocation =
      'Hummingbird/images/itemCatalog/itemCatalog${item.itemID}.jpg'; //store path to database in variable to reference later
    }

    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());


    docRef.set(item);
  }

  deleteItemInCatalog(Item item){
    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());

    docRef.delete();

  }

  uploadPic(String path, Item item) async {
    final storageRef = FirebaseStorage.instance.ref();

    final refString =
        'Hummingbird/images/itemCatalog/itemCatalog${item.itemID}.jpg';

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

  Future<String> downloadPic(Item item) async {
    final storageRef = FirebaseStorage.instance.ref();

    if (item.picLocation != null) {
      final pathReference = storageRef.child(item.picLocation!);
      final imageUrl = await pathReference.getDownloadURL();
      return imageUrl;
    }

    return '';
  }

  ///*** Admin ****

  updateItem(Item item, String? path) async{
    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());

    //add picture to storage if its not null
    if (path != null) {
      uploadPic(path, item); //created function to upload pic to database
      item.picLocation =
      'Hummingbird/images/itemCatalog/itemCatalog${item.itemID}.jpg'; //store path to database in variable to reference later
    }

    //update item
    docRef.update({'itemName':item.itemName, 'retail':item.retail,
      'itemDescription':item.itemDescription, 'amountAvailable':item.amountAvailable,
      'onSale':item.onSale,'cost':item.cost,
      'picLocation':item.picLocation});


  }


  deleteItem(Item item){

    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());

    docRef.delete();
  }
}
