import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Custom/Users.dart';
import 'package:project_blue_bird/Directory/Nest/NestScreen.dart';
import 'package:project_blue_bird/Enums/CreateAccount%20Status.dart';
import 'package:project_blue_bird/Enums/Sign%20In%20Status.dart';
import 'package:project_blue_bird/Firebase/UsersFirebase.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
// Needed because we can't import `dart:html` into a mobile app,
// while on the flip-side access to `dart:io` throws at runtime (hence the `kIsWeb` check below)


import 'package:flutter/foundation.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController signInEmail = TextEditingController();
  TextEditingController signInPassword = TextEditingController();

  bool signUp = false;

  UsersFirebase usersFirebase = UsersFirebase();

  Users users = Users(
      firstName: '',
      lastName: '',
      email: '',
      birthday: DateTime.now(),
      id: '',
      token: '',
      activeAccount: true,
      admin: false,
      phoneNumber: '',
      notificationsOn: true);

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
              Color(0x65baf4d7),
              Color(0x65c8f4e1),
              Color(0x65dff6e8),
              Color(0x65c9f3d3),
              Color(0x65dfefc6),
              Color(0x65dbf4b5),
              Color(0x65f5e5d6),
              Color(0x65f5e5d6),
              Color(0x65bbf0f4),
              Color(0x65bbf0f4),
              Color(0x65bcc7f4),
              Color(0x50dfefc6),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SafeArea(
              child: Text(
                'HummingBird Creations',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      height: 200,
                      child: Image.asset("lib/Images/bird-6967128_1920.png"),
                    ),
                  ),
                  bottomPanel(context),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget signUpPanel(BuildContext context) {
    return Container(
      // key: UniqueKey(),
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
          //color: Colors.white.withOpacity(.45),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 42.0, right: 42, bottom: 12),
              child: TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                    labelText: 'First Name...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 42.0, right: 42, bottom: 12),
              child: TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                    labelText: 'Last Name...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 42.0, right: 42, bottom: 12),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 42.0, right: 42),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
                style: const TextStyle(fontSize: 10),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 38.0, left: 38),
              child: Divider(
                thickness: 2,
              ),
            ),
            ElevatedButton(
                onPressed: () async {


                  setState(() {
                    users.firstName = firstNameController.text;
                    users.lastName = lastNameController.text;
                    users.email = emailController.text;
                  });

                  if (firstNameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    errorMessage(context, 'Please fill out required fields.');
                  } else {

                    CreateAccountStatus status = await usersFirebase.createUser(
                        users, passwordController.text);

                    if(status == CreateAccountStatus.emailInUse){
                      errorMessage(context, 'Email in use.');
                    }else if(status == CreateAccountStatus.weakPassword){
                      errorMessage(context, 'Weak password. Passwords must be 6 characters long.');
                    }else if(status == CreateAccountStatus.passwordNotLongEnough){
                      errorMessage(context, 'Weak password. Passwords must be 6 characters long.');
                    }else if(status == CreateAccountStatus.incorrectEmailFormat){
                      errorMessage(context, 'Email is incorrectly formatted.');
                    }else if(status == CreateAccountStatus.success){


                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Signed in with ${users.email}")));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NestScreen(
                                users: users,
                              )));
                    }

                  }
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                )),
            SafeArea(
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Already have an account? Sign in")),
            )
          ],
        ),
      ),
    );
  }

  Widget signInPanel(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // key: UniqueKey(),
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
            //color: Colors.white.withOpacity(.45),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 42.0, right: 42, bottom: 12),
                child: TextField(
                  controller: signInEmail,
                  decoration: const InputDecoration(
                      labelText: 'Enter Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 42.0, right: 42, bottom: 12),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 38.0, left: 38),
                child: Divider(
                  thickness: 2,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {

                    if(signInEmail.text.isEmpty || passwordController.text.isEmpty){
                      errorMessage(context, 'Please fill out required fields.');
                    }else{
                      SignInStatus status =
                      await usersFirebase.signIn(
                          signInEmail.text, passwordController.text);


                      if(status == SignInStatus.invalidEmail){
                        errorMessage(context, 'Invalid Email. If you created an account with google or apple, sign in using one of those options.');
                      }else if(status == SignInStatus.disabled){
                        errorMessage(context, 'Account has been disabled. If you created an account with google or apple, sign in using one of those options.');
                      }else if(status == SignInStatus.userNotFound){
                        errorMessage(context, 'User not found. If you created an account with google or apple, sign in using one of those options.');
                      }else if(status == SignInStatus.wrongPassword){
                        errorMessage(context, 'Wrong Password. If you created an account with google or apple, sign in using one of those options.');
                      }else if(status == SignInStatus.invalidCred){
                        errorMessage(context, 'Invalid Credentials. If you created an account with google or apple, sign in using one of those options.');
                      }else if(status == SignInStatus.success){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Sign In with ${users.email}")));


                    //if signed in, navigate to main screen
                    if (users.firstName != 'Not Signed In')
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => NestScreen(
                    users: users,
                    )));
                      }
                    }

                    //if (status == SignInStatus)
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )),
              SafeArea(
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text("New member? Create new account")),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> errorMessage(BuildContext context, String errorMessage) {
    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
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
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Missing information",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(errorMessage,
                                      style:
                                      const TextStyle(fontSize: 18, color: Colors.black),textAlign: TextAlign.center,),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Exit",
                                        style: TextStyle(color: Colors.black),
                                      ))
                                ],
                              ),
                            ),
                          );
                        });
  }

  Padding googleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 42.0, left: 42, top: 12),
      child: ElevatedButton(
        onPressed: () async {


         Users users = await usersFirebase.signInWithGoogle();

         //show success message
         ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text("Sign In with ${users.email}")));

         if (users.firstName != 'Not Signed In')
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => NestScreen(
                     users: users,
                   )));
        },
        style: ButtonStyle(
            maximumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width, 50)),
            elevation: MaterialStateProperty.all(0),
            backgroundColor:
                MaterialStateProperty.all(Colors.blue.withOpacity(0.001)),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
            ),
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.black.withOpacity(.35), width: 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 30,
                child: Image.asset('lib/Images/google-1088004_1920.png')),
            const Text("Connect with Google",
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Padding appleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 42.0, left: 42, top: 8, bottom: 8),
      child: ElevatedButton(
        onPressed: () async {
          ///

          await usersFirebase.signInWithApple();
          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text("Sign In with ${users.email}")));
          //
          //
          //
          // //if signed in, navigate to main screen
          // if (users.firstName != 'Not Signed In')
          // Navigator.push(
          // context,
          // MaterialPageRoute(
          // builder: (context) => NestScreen(
          // users: users,
          // )));


        },
        style: ButtonStyle(
            maximumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width, 50)),
            // padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
            //     horizontal: 35,
            //     vertical: 15
            // ),
            // ),
            elevation: MaterialStateProperty.all(0),
            backgroundColor:
                MaterialStateProperty.all(Colors.blue.withOpacity(0.001)),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
            ),
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.black.withOpacity(.35), width: 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 30,
                child: Image.asset(
                    'lib/Images/apple-logo-52C416BDDD-seeklogo.com.png')),
            const Text("Connect with Apple",
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget bottomPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 48),
      child: Container(
        key: UniqueKey(),
        decoration: const BoxDecoration(
            // color: Colors.white.withOpacity(.45),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return signUpPanel(context);
                            });
                      });
                    },
                    style: ButtonStyle(
                        maximumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 50)),
                        // padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                        //     horizontal: 35,
                        //     vertical: 15
                        // ),
                        // ),
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.blue.withOpacity(0.001)),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                        ),
                        side: MaterialStateProperty.all(BorderSide(
                            color: Colors.black.withOpacity(.35), width: 2))),
                    child: const Text("Sign Up",
                        style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const NestScreen()));

                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return signInPanel(context);
                            });
                      });
                    },
                    style: ButtonStyle(
                        maximumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 50)),
                        // padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                        //     horizontal: 35,
                        //     vertical: 15
                        // ),
                        // ),
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.blue.withOpacity(0.001)),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                        ),
                        side: MaterialStateProperty.all(BorderSide(
                            color: Colors.black.withOpacity(.35), width: 2))),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(right: 42.0, left: 42),
              child: Divider(
                thickness: 2,
              ),
            ),

            //Google button
            googleButton(context),

            //Apple Button
            appleButton(context),
          ],
        ),
      ),
    );
  }
}
