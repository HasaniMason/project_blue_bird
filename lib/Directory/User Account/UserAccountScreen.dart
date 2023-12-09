import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Directory/User%20Account/EditUserAccountScreen.dart';

import '../../Custom Widgets/OrderWidget.dart';
import '../../Custom/ShopOrders.dart';
import '../../Custom/Users.dart';
import '../Nest/OpenSelectedOrderScreen.dart';



class UserAccountScreen extends StatefulWidget {
  Users users;

  UserAccountScreen({required this.users});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {

  late Stream<QuerySnapshot> cartStream;
  List<DocumentSnapshot> cartList = [];

  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('shopOrders')
        .where('clientId', isEqualTo: widget.users.id)
        //.where('customOrder', isEqualTo: false)
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
              child: Center(
                child: Column(

                  children: [

                    topInfo(),


                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius
                                .circular(50), topRight: Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.grey
                              )
                            ]
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Transactions', style: TextStyle(
                                      fontWeight: FontWeight.bold),),
                                ],
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
                                      itemBuilder: (BuildContext context,
                                          int index) {
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
                                            date: (cartList[index]['date'] as Timestamp)
                                                .toDate(),
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
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
  Widget initials(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.users.firstName.isNotEmpty ?
        Text(widget.users.firstName[0].toUpperCase(),style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold
        ),):
        const SizedBox(),

        widget.users.lastName.isNotEmpty ?
        Text(widget.users.lastName[0].toUpperCase(),style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold
        ),):
        const SizedBox(),
      ],
    );
  }

  Widget topInfo() {
    return  Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 16),
      child: Column(
                children: [

                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_outlined)),

                        IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditUserAccountScreen(users: widget.users,)));
                        },icon:Icon(Icons.edit))
                      ],
                    ),
                  ),

                   CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: initials(),
                  ),

                  Text("${widget.users.firstName} ${widget.users.lastName}",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32
                  ),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.18),
                          borderRadius: const BorderRadius.all(Radius.circular(20))
                        ),
                        child:  Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(

                              children: [


                                Text("Account Status",style: TextStyle(color: Colors.grey.withOpacity(.99))),

                                widget.users.activeAccount ?
                                Text("Active",style: TextStyle(fontWeight: FontWeight.bold),):
                                Text("Inactive",style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                        ),
                      ),


                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.18),
                            borderRadius: const BorderRadius.all(Radius.circular(20))
                        ),
                        child:  Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(

                              children: [
                                Text("Member Since",style: TextStyle(color: Colors.grey.withOpacity(.99)),),
                                Text("${widget.users.birthday.month}/${widget.users.birthday.day}/${widget.users.birthday.year}",style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 26, right: 26),
                    child: Container(
                      //width: 150,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.18),
                          borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child:  Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(

                            children: [
                              Text("Email",style: TextStyle(color: Colors.grey.withOpacity(.99)),),
                              Text(widget.users.email,style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
    );
  }
}
