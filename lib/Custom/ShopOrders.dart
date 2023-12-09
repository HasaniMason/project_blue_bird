import 'package:cloud_firestore/cloud_firestore.dart';

class ShopOrders {
  num total;
  String streetAddress;
  String streetAddressContinued;
  String zipCode;
  String city;
  String state;
  String id;

  String firstName;
  String lastName;
  String phoneNumber;
  String clientId;
  String email;
  DateTime date;

  bool customOrder;

  bool orderComplete;
  bool orderApproved;
  String? picLocation;

  ShopOrders(
      {required this.total,
        required this.streetAddress,
        required this.streetAddressContinued,
        required this.zipCode,
        required this.city,
        required this.state,
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.phoneNumber,
        required this.clientId,
        required this.email,
        required this.date,
       required this.customOrder,
      required this.orderComplete,
      this.picLocation,
      required this.orderApproved});

  factory ShopOrders.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return ShopOrders(
        total: data?['total'],
        streetAddress: data?['streetAddress'],
        streetAddressContinued: data?['streetAddressContinued'],
        zipCode: data?['zipCode'],
        city: data?['city'],
        state: data?['state'],
        id: data?['id'],
        firstName: data?['firstName'],
        lastName: data?['lastName'],
        phoneNumber: data?['phoneNumber'],
        clientId: data?['clientId'],
        email: data?['email'],
        date: (data?['date'] as Timestamp).toDate(),
    customOrder: data?['customOrder'],
    orderComplete: data?['orderComplete'],
    picLocation: data?['picLocation'],
    orderApproved: data?['orderApproved']);
  }

  Map<String, dynamic> toFireStore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'id': id,
      'phoneNumber': phoneNumber,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'total': total,
      'streetAddress': streetAddress,
      'streetAddressContinued': streetAddressContinued,
      'clientId': clientId,
      'date':date,
      'customOrder':customOrder,
      'orderComplete':orderComplete,
      'picLocation':picLocation,
      'orderApproved':orderApproved
    };
  }
}
