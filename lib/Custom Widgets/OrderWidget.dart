import 'package:flutter/material.dart';

import '../Custom/ShopOrders.dart';


class OrderWidget extends StatelessWidget {

  final ShopOrders shopOrders;

  OrderWidget({
    super.key,
    required this.shopOrders
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.grey
            )
          ]
        ),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  shopOrders.customOrder ?
                  Image.asset('lib/Images/school-1555907_1920.png'):
                  Image.asset('lib/Images/open-576209_1920.png')

              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  shopOrders.customOrder ?
                  const Text("Custom Order",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  ),):
                  const Text("Store Order",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  ),),

                  const Text("for: Dedrick Horton"),

                   Text("Date: ${shopOrders.date.month}/${shopOrders.date.day}/${shopOrders.date.year}")
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("\$${shopOrders.total}",style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.green
              ),),
            )
          ],
        ),
      ),
    );
  }
}