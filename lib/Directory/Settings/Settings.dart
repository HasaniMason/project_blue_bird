import 'package:flutter/material.dart';
import 'package:project_blue_bird/Directory/Nest/CartScreen.dart';
import 'package:project_blue_bird/Directory/Nest/RecentOrdersScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Custom/Users.dart';

class SettingsScreen extends StatefulWidget {
 final Users users;

 SettingsScreen({required this.users});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
 bool toggle = true;

 final Uri uri = Uri.parse(
     'https://www.termsfeed.com/live/ceaddc20-add7-4c0f-9454-d615ded08dad');

 final Uri returnUir = Uri.parse('https://www.termsfeed.com/live/292fdaf2-2cb6-4a1f-9d92-84308e7f9e22');


 Future _launchUrl(Uri uri) async {
   if (!await launchUrl(uri)) {
     throw Exception('Could not launch url');
   }
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //height: MediaQuery.of(context).size.height,
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
                  ])),
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
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),


              settingsList()

            ],
          )),
    );
  }

  Widget settingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    const Text("Notifications",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),

                    Switch(
                        activeColor: Colors.blue,
                        inactiveTrackColor: Colors.grey,
                        value: toggle,
                        onChanged: (value) async {
                          setState(() {
                            toggle = value;
                          });

                        })
                  ],
                ),

                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RecentOrdersScreen(users: widget.users,)));
                }, child: const Text("Past Transactions",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black
                ),)),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen(users: widget.users,)));

                }, child: const Text("My Cart",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black
                ),)),
                TextButton(onPressed: (){
                  _launchUrl(uri);

                }, child: const Text("Privacy Policy",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black
                ),)),
                TextButton(onPressed: (){
                  _launchUrl(returnUir);
                }, child: const Text("Return Policy",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black
                ),))
              ],
            );
  }
}
