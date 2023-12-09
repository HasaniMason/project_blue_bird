

import 'package:cloud_firestore/cloud_firestore.dart';

class Business{
  num totalBalance;

  Business({required this.totalBalance});

  factory Business.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Business(
        totalBalance: data?['totalBalance']);
  }

  Map<String, dynamic> toFireStore(){
    return{
      'totalBalance':totalBalance,
    };
  }

}