import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Directory/Admin%20Panel/SelectedCustomOrderScreen.dart';

import '../../Custom Widgets/OrderWidget.dart';
import '../../Custom/ShopOrders.dart';



class CustomRequestScreen extends StatefulWidget {
  const CustomRequestScreen({Key? key}) : super(key: key);

  @override
  State<CustomRequestScreen> createState() => _CustomRequestScreenState();
}

class _CustomRequestScreenState extends State<CustomRequestScreen> {


  late Stream<QuerySnapshot> cartStream;
  List<DocumentSnapshot> cartList = [];

  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('shopOrders')
        //.where('orderApproved', isEqualTo: false)
        .where('customOrder', isEqualTo: true)
        .snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
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
                  ]
              )
          ),
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_outlined)),
                  ],
                ),
              ),
              const Center(
                child: Text(
                  'Custom Requests',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
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
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
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
                                color: Colors.black
                            ),
                            textAlign: TextAlign.center,
                          ));
                    }

                    return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          ShopOrders thisShopOrders = ShopOrders(
                              total: cartList[index]['total'],
                              streetAddress: cartList[index]['streetAddress'],
                              streetAddressContinued: cartList[index]['streetAddressContinued'],
                              zipCode: cartList[index]['zipCode'],
                              city: cartList[index]['city'],
                              state: cartList[index]['state'],
                              id: cartList[index]['id'],
                              firstName: cartList[index]['firstName'],
                              lastName: cartList[index]['lastName'],
                              phoneNumber: cartList[index]['phoneNumber'],
                              clientId: cartList[index]['clientId'],
                              email: cartList[index]['email'],
                              date: (cartList[index]['date']as Timestamp).toDate(),
                              customOrder: cartList[index]['customOrder'],
                              orderComplete: cartList[index]['orderComplete'],
                          picLocation: cartList[index]['picLocation'],
                              orderApproved: cartList[index]['orderApproved']);



                          return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedCustomOrderScreen(shopOrders: thisShopOrders)));
                              },
                              child: OrderWidget(shopOrders: thisShopOrders));
                        },
                        separatorBuilder:
                            (BuildContext context, int index) {
                          return const SizedBox();
                        },
                        itemCount: cartList.length);
                  },
                ),
              ),

            ],
          ),
        )
      );
  }
    );
  }
}
