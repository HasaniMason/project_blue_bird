import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  double total;
  String streetAddress;
  String streetAddressContinued;
  String zipCode;
  String city;
  String state;
  String id;

  Cart(
      {required this.total,
        required this.streetAddress,
        required this.streetAddressContinued,
        required this.zipCode,
        required this.city,
        required this.state,
        required this.id});

  factory Cart.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Cart(
        total: data?['total'],
        streetAddress: data?['streetAddress'],
        streetAddressContinued: data?['streetAddressContinued'],
        zipCode: data?['zipCode'],
        city: data?['city'],
        state: data?['state'],
        id: data?['id']);
  }

  Map<String, dynamic> toFireStore(){
    return{
      'total':total,
      'streetAddress':streetAddress,
      'streetAddressContinued':streetAddressContinued,
      'zipCode': zipCode,
      'state': state,
      'id': id,
    };
  }
}
