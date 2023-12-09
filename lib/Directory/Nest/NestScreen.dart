import 'package:flutter/material.dart';
import 'package:project_blue_bird/Custom/Constants.dart';
import 'package:project_blue_bird/Directory/Nest/CartScreen.dart';
import 'package:project_blue_bird/Directory/Nest/ContactUsScreen.dart';
import 'package:project_blue_bird/Directory/Nest/Custom%20Crafts/CustomCraftsScreen.dart';
import 'package:project_blue_bird/Directory/Nest/RecentOrdersScreen.dart';
import 'package:project_blue_bird/Directory/Nest/Shop/ShopScreen.dart';
import 'package:project_blue_bird/Directory/Settings/Settings.dart';
import 'package:project_blue_bird/Directory/User%20Account/EditUserAccountScreen.dart';
import 'package:project_blue_bird/Directory/User%20Account/UserAccountScreen.dart';
import 'package:project_blue_bird/Firebase/UsersFirebase.dart';
import 'package:project_blue_bird/Sign%20In/LoadPage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Custom/Users.dart';
import '../Admin Panel/AdminPage.dart';



class NestScreen extends StatefulWidget {
  final Users users;

  NestScreen({required this.users});

  @override
  State<NestScreen> createState() => _NestScreenState();
}

class _NestScreenState extends State<NestScreen> {


  UsersFirebase usersFirebase = UsersFirebase();
  ConstantDatabase constantDatabase = ConstantDatabase();


  final Uri uri = Uri.parse(
      'https://www.termsfeed.com/live/ceaddc20-add7-4c0f-9454-d615ded08dad');


  Future _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch url');
    }
  }



  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        drawer: drawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                elevation: 10,
                type: MaterialType.transparency,
                child: Container(
                  height: 350,
                  decoration: const BoxDecoration(
                      boxShadow: [

                      ],
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
                  child:  topInfo(context),
                ),
              ),



              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopScreen(users: widget.users,)));
                  },
                  child: const PictureButton(pic: 'lib/Images/hangers-1850082_1920.jpg',title: 'Shop',)),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 200,
                    //width: 250,
                    child: Image.asset('lib/Images/bird-6967128_1920.png')
                ),
              ),


               Padding(
                 padding: const EdgeInsets.only(bottom: 16.0),
                 child: GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomCraftsScreen(users: widget.users,)));
                     },
                     child: const PictureButton(pic: 'lib/Images/tools-864983_1920.jpg',title: 'Custom Crafts',)),
               ),



            ],

          ),
        ),
      ),
    );
  }

  Column topInfo(BuildContext context) {
    return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const SizedBox(width: 25,),

                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Your Nest",style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),),
                      ),

                      Builder(
                        builder: (context)=>IconButton(onPressed: (){
                          Scaffold.of(context).openDrawer();

                        },icon: const Icon(Icons.menu),),
                      )
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UserAccountScreen(users: widget.users,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey.withOpacity(.2)
                      ),

                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                           Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: initials(),
                              ),
                            ),
                          ),

                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${widget.users.firstName} ${widget.users.lastName}",style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                ),),
                                 Text("${widget.users.email}"),
                                 Text("Member since: ${widget.users.birthday.month}/${widget.users.birthday.day}/${widget.users.birthday.year}")
                              ],
                            ),
                          ),

                          IconButton(onPressed: (){

                            showModalBottomSheet(context: context, builder: (context){
                              return  EditUserAccountScreen(users: widget.users,);
                            });

                          }, icon: const Icon(Icons.edit))
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                       boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),

                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(onPressed: (){
                          showModalBottomSheet(context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (context){
                                return  RecentOrdersScreen(users: widget.users,);
                              });
                        }, child: const Text("Recent Orders",style: TextStyle(
                            fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),)),

                        TextButton(onPressed: (){
                          showModalBottomSheet(context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (context){
                            return CartScreen(users: widget.users,);
                          });
                        }, child: const Text("Cart",style: TextStyle(
                            fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),))
                        ,

                        TextButton(onPressed: (){
                          showModalBottomSheet(context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (context){
                                return const ContactUsScreen();
                              });
                        }, child: const Text("Contact Us",style: TextStyle(
                            fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),))


                      ],
                    ),
                  ),
                )

              ],
            );
  }


  Drawer drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:  [
          const DrawerHeader(
            decoration: BoxDecoration(
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
                    ])
            ), child: Center(child: Text("Hummingbird Creations",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
          ),)),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> UserAccountScreen(
                users: widget.users,
              )));
            },
          ),

          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: const Text('Admin Panel'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminPage(users: widget.users,)));
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsScreen(users:  widget.users,)));

            },
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: (){
              _launchUrl(uri);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Sign Out'),
            onTap: () async {
             await usersFirebase.signOutUser();

             Navigator.pushAndRemoveUntil(
                 context,
                 MaterialPageRoute(builder: (context) => const LoadPage()),
                     (route) => false);

            },
          ),

          const SizedBox(
            height: 75,
          ),

          SizedBox(
              height: 200,
              //width: 250,
              child: Image.asset('lib/Images/bird-6967128_1920.png')
          ),

           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text("Version: ${constantDatabase.version}",style: TextStyle(fontWeight: FontWeight.bold),),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [

                   Text(
                     'Powered by',
                     style: TextStyle(
                         fontWeight: FontWeight.bold
                     ),
                   ),
                   SizedBox(
                       height: 100,
                       width: 100,
                       child: Image.asset('lib/Images/CITex_noBack.png')),
                 ],
               )
             ],
           ),





        ],
      ),
    );
  }

  Widget initials(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.users.firstName.isNotEmpty ?
            Text(widget.users.firstName[0].toUpperCase(),style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),):
            const SizedBox(),

        widget.users.lastName.isNotEmpty ?
        Text(widget.users.lastName[0].toUpperCase(),style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),):
        const SizedBox(),
      ],
    );
  }

}

class PictureButton extends StatelessWidget {
  final String pic;
  final String title;


  const PictureButton({
    super.key,
    required this.pic,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Opacity(
                  opacity: .4,
                  child: Container(
                    height:75,
                    width: MediaQuery.of(context).size.width-40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 2,
                              color: Colors.black
                          )
                        ],
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        child: Image.asset(pic,fit: BoxFit.fitWidth,)),
                  ),
                )
              ],
            ),
          ),
          Text(title,style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),),
        ],
      ),
    );
  }
}
