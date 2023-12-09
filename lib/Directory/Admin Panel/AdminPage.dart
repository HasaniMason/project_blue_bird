import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Custom%20Widgets/InputFields.dart';
import 'package:project_blue_bird/Custom%20Widgets/TextFields.dart';
import 'package:project_blue_bird/Custom/Business.dart';
import 'package:project_blue_bird/Directory/Admin%20Panel/CustomRequestsScreen.dart';
import 'package:project_blue_bird/Directory/Admin%20Panel/MyCatalogScreen.dart';
import 'package:project_blue_bird/Directory/Admin%20Panel/UserScreen.dart';
import 'package:project_blue_bird/Firebase/UsersFirebase.dart';

import '../../Custom Widgets/OrderWidget.dart';
import '../../Custom/ShopOrders.dart';
import '../../Custom/Users.dart';
import '../Nest/OpenSelectedOrderScreen.dart';


class AdminPage extends StatefulWidget {

  final Users users;

  const AdminPage({
    super.key,
    required this.users
  });

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  late Stream<QuerySnapshot> cartStream;
  List<DocumentSnapshot> cartList = [];

  TextEditingController realignController = TextEditingController();
  UsersFirebase usersFirebase = UsersFirebase();

  String? total;

  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('shopOrders')

       // .where('customOrder', isEqualTo: true)
        .snapshots();

    final docRef = FirebaseFirestore.instance.collection('totalBalance').doc('123456').withConverter(
        fromFirestore: Business.fromFireStore,
        toFirestore: (Business business, options) => business.toFireStore());

    final docSnap = await docRef.get();
    total = docSnap.data()?.totalBalance.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
      return Scaffold(
        // backgroundColor: Colors.yellow,
          body: Column(
            children: [
              topUI(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "All Activity",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    TextButton(onPressed: () {}, child: const Text('See More'))
                  ],
                ),
              ),
              activityList(),
            ],
          ));
  }
    );
  }

  Stack topUI() {
    return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 300,
                      child: Image.asset(
                        "lib/Images/bird-295026_1920.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      height: 140,
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
                              ]
                          )
                      ),
                      //color: Colors.grey[200],
                    )
                  ],
                ),
                Positioned(
                  top: 250,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total balance:',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'US \$${total ?? ''}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18),
                                  )
                                ],
                              ),
                              ElevatedButton(onPressed: (){
                                showModalBottomSheet(context: context, builder: (context){
                                  return Container(
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
                                            ]
                                        )
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Text("Enter dollar amount to realign total balance.",style: TextStyle(
                                            fontWeight: FontWeight.bold
                                          ),),
                                          TextFields(textEditingController: realignController, hintText: 'Enter Balance', iconData: Icons.attach_money_outlined, textInputType: TextInputType.number),


                                          ElevatedButton(onPressed: (){
                                            usersFirebase.realignTotalBalance(double.parse(realignController.text)).whenComplete(() => {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Balance Realigned"))),
                                              Navigator.pop(context),
                                            });
                                          }, child: const Text("Submit",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),))
                                        ],
                                      ),
                                    )
                                  );
                                });
                              }, child: const Text("Realign",style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),))
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserScreen()));
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                              child: const Text(
                                "Users",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCatalogScreen(users: widget.users,)));
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                              child: const Text(
                                "My Catalog",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomRequestScreen()));

                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                                child: const Icon(Icons.inbox_outlined,color: Colors.black,),
                              ),
                            ),
                          )
                        ],
                      ),
                      // Container(
                      //   height: 100,
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Flexible(
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child:
                      //           Image.asset('lib/Images/animal-2727126_1920.png'),
                      //         ),
                      //       ),
                      //        const Flexible(
                      //         child: Padding(
                      //           padding: EdgeInsets.only(top: 8.0),
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Center(
                      //                 child: Text(
                      //                   "Connect with users",
                      //                   style: TextStyle(
                      //                       fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,
                      //                 ),
                      //               ),
                      //               Center(
                      //                 child: Text(
                      //                   "View More",
                      //                   style: TextStyle(fontSize: 16),textAlign: TextAlign.center,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       IconButton(onPressed: () {
                      //
                      //       }, icon: const Icon(Icons.forward))
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            );
  }

  Expanded activityList() {
    return Expanded(
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
                      orderApproved: cartList[index]['orderApproved']);



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
                    separatorBuilder:
                        (BuildContext context, int index) {
                      return const SizedBox();
                    },
                    itemCount: cartList.length);
              },
            ),
          );
  }
}


