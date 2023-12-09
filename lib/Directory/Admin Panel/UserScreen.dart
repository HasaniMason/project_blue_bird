import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Firebase/UsersFirebase.dart';

import '../../Custom/Users.dart';


class UserScreen extends StatefulWidget {
  const UserScreen({super.key});




  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  late Stream<QuerySnapshot> userStream;
  List<DocumentSnapshot> userList = [];

  setUp()async{
    userStream = FirebaseFirestore.instance
        .collection('users')
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
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
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
                  'Users',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),

              Expanded(
                child: StreamBuilder(
                  stream: userStream,
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
                    userList = snapshot.data!.docs;

                    if (userList.isEmpty) {
                      return Center(
                          child: Text(
                            'No Users',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                color:
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .primary),
                            textAlign: TextAlign.center,
                          ));
                    }

                    return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          Users user = Users(firstName: userList[index]['firstName'],
                              lastName: userList[index]['lastName'],
                              email: userList[index]['email'],
                              birthday: (userList[index]['birthday'] as Timestamp).toDate(),
                              id: userList[index]['id'],
                              token: userList[index]['token'],
                              activeAccount: userList[index]['activeAccount'],
                              admin: userList[index]['admin'],
                              phoneNumber: userList[index]['phoneNumber'],
                              notificationsOn: userList[index]['notificationsOn']);

                          return UserContainer(users: user);

                        },
                        separatorBuilder:
                            (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(),
                          );
                        },
                        itemCount: userList.length);
                  },
                ),
              ),

            ],
          ),
        ),
      );
  }
    );
  }
}



class UserContainer extends StatefulWidget {
  final Users users;


   UserContainer({super.key, required this.users});

  @override
  State<UserContainer> createState() => _UserContainerState();
}

class _UserContainerState extends State<UserContainer> {

  UsersFirebase usersFirebase = UsersFirebase();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Row(

            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(.3),
                radius: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.users.firstName.isNotEmpty ?
                    Text(widget.users.firstName[0].toUpperCase(),style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),): const SizedBox(),


                    widget.users.lastName.isNotEmpty ?
                    Text(widget.users.lastName[0].toUpperCase(),style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),): const SizedBox()
                  ],
                ),
              ),
            ],
          ),



          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.users.firstName} ${widget.users.lastName}",style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
                Text(widget.users.email)
              ],
            ),
          ),

          Spacer(),

          IconButton(onPressed: (){
            showDialog(context: context, builder: (BuildContext context){
              return Dialog(
                child: Container(
                  height: 200,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      !widget.users.admin?
                      Text('Make ${widget.users.firstName} an admin?',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,):
                      Text('Make ${widget.users.firstName} not an admin?',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,),



                      TextButton(onPressed: (){
                        usersFirebase.toggleUserAdmin(widget.users);
                        Navigator.pop(context);

                      }, child: Text("Yes",style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),)),

                      TextButton(onPressed: (){
                      Navigator.pop(context);

                      }, child: Text("No",style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),))
                    ],
                  ),
                ),
              );
            });

          }, icon: Icon(Icons.more_horiz_outlined))

        ],
      ),
    );
  }
}

