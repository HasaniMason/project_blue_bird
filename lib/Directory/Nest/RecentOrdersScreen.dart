import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Custom/ShopOrders.dart';
import 'package:project_blue_bird/Directory/Nest/OpenSelectedOrderScreen.dart';

import '../../Custom Widgets/OrderWidget.dart';
import '../../Custom/Items.dart';
import '../../Custom/Users.dart';

class RecentOrdersScreen extends StatefulWidget {
  final Users users;

  RecentOrdersScreen({required this.users});

  @override
  State<RecentOrdersScreen> createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen> {
  late Stream<QuerySnapshot> cartStream;
  List<DocumentSnapshot> cartList = [];

  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('shopOrders')
        .where('clientId', isEqualTo: widget.users.id)
        .where('customOrder', isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
              body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x80baf4d7),
                  Color(0x80c8f4e1),
                  Color(0x80dff6e8),
                  Color(0x80c9f3d3),
                  Color(0x80dfefc6),
                  Color(0x80dbf4b5),
                  Color(0x80f5e5d6),
                  Color(0x80bbf0f4),
                  Color(0x80bbf0f4),
                  Color(0x80bcc7f4),
                  Color(0x80dfefc6)
                ],
              ),
            ),
            child: Column(
              children: [
                const SafeArea(
                  child: Center(
                    child: Text(
                      'Recent Orders',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Any orders without a price has yet to be approved. Please wait for further contact.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: cartStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      //if there is an error
                      if (snapshot.hasError) {
                        return const Text('Error');
                      }
                      //while it connects
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      cartList = snapshot.data!.docs;

                      if (cartList.isEmpty) {
                        return const Center(
                            child: Text(
                          'No previous orders.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ));
                      }

                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            ShopOrders thisShopOrders = ShopOrders(
                                total: cartList[index]['total'],
                                streetAddress: cartList[index]['streetAddress'],
                                streetAddressContinued: cartList[index]
                                    ['streetAddressContinued'],
                                zipCode: cartList[index]['zipCode'],
                                city: cartList[index]['city'],
                                state: cartList[index]['state'],
                                id: cartList[index]['id'],
                                firstName: cartList[index]['firstName'],
                                lastName: cartList[index]['lastName'],
                                phoneNumber: cartList[index]['phoneNumber'],
                                clientId: cartList[index]['clientId'],
                                email: cartList[index]['email'],
                                date: (cartList[index]['date'] as Timestamp)
                                    .toDate(),
                                customOrder: cartList[index]['customOrder'],
                                orderComplete: cartList[index]['orderComplete'],
                                orderApproved: cartList[index]
                                    ['orderApproved']);

                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OpenSelectedOrderScreen(
                                                  users: widget.users,
                                                  shopOrders: thisShopOrders)));
                                },
                                child: OrderWidget(shopOrders: thisShopOrders));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          },
                          itemCount: cartList.length);
                    },
                  ),
                ),
              ],
            ),
          ));
        });
  }
}
