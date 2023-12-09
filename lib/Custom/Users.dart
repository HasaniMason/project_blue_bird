

//to not be confused with User from firebase auth
import 'package:cloud_firestore/cloud_firestore.dart';

class Users{

  String firstName; //client firstname
  String lastName; //client lastname
  String email; //client email
  DateTime birthday; //client birthday
  String phoneNumber;

  String id; //unique id for client's account
  String token; //unique token to use for push notifications
  bool activeAccount; //if account is active
  bool admin; //if account has admin status or not

  bool notificationsOn;
  num? cartTotal;

  String? nextBooking;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? zipCode;

  num? version;
  bool? canPost;   //can control if user can post

  //specify if these variable are required or not. If not must declare variable using '?' to the right of variable type
  Users(
      {required this.firstName,
        required this.lastName,
        required this.email,
        required this.birthday,
        required this.id,
        required this.token,
        required this.activeAccount,
        required this.admin,
        required this.phoneNumber,
        required this.notificationsOn,
        this.cartTotal,
        this.nextBooking,
        this.city,
        this.state,
        this.zipCode,
        this.addressLine1,
        this.addressLine2,
        this.version,
        this.canPost});

  factory Users.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Users(
        firstName: data?['firstName'],
        lastName: data?['lastName'],
        email: data?['email'],
        birthday: data?['birthday'].toDate(),
        id: data?['id'],
        token: data?['token'],
        activeAccount: data?['activeAccount'],
        admin: data?['admin'],
        phoneNumber: data?['phoneNumber'],
        notificationsOn: data?['notifications'] ?? true,
        nextBooking: data?['nextBooking'] ?? '',
        cartTotal: data?['cartTotal'],
        city: data?['city'],
        state: data?['state'],
        zipCode: data?['zipCode'],
        addressLine1: data?['addressLine1'],
        addressLine2: data?['addressLine2'],
        version: data?['version'],
        canPost: data?['canPost']);
  }

  Map<String, dynamic> toFireStore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'birthday': birthday,
      'id': id,
      'token': token,
      'activeAccount': activeAccount,
      'admin': admin,
      'phoneNumber': phoneNumber,
      'notificationsOn': notificationsOn,
      'nextBooking': nextBooking,
      'cartTotal': cartTotal,
      'city':city,
      'state':state,
      'zipCode':zipCode,
      'addressLine1': addressLine1,
      'addressLine2':addressLine2,
      'version':version,
      'canPost':canPost,
    };
  }

}