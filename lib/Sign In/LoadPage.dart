import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Directory/Nest/NestScreen.dart';
import 'package:project_blue_bird/Firebase/UsersFirebase.dart';
import 'package:project_blue_bird/Sign%20In/SignInPage.dart';

import '../Custom/Users.dart';



class LoadPage extends StatefulWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {

  UsersFirebase usersFirebase = UsersFirebase();


  decideState()async{

    Users? users;
    if(FirebaseAuth.instance.currentUser  != null) {
     // usersFirebase.signOutUser();
      users = await usersFirebase.getUser();


    }


    if(FirebaseAuth.instance.currentUser == null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
    }else{


      Navigator.push(context, MaterialPageRoute(builder: (context)  =>NestScreen(users: users!,)));

    }

  }

  @override
  void initState(){
    super.initState();

    Future.delayed(const Duration(seconds: 3),(){
      decideState();
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
        child: Scaffold(
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
                ],
              ),
            ),

            child: Center(
              child: Container(
                  height: 300,
                  width: 200,
                  child: Image.asset('lib/Images/bird-6967128_1920.png')),
            ),
          ),
        ),
    );
  }
}
