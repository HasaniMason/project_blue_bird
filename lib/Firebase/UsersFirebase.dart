


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_blue_bird/Enums/CreateAccount%20Status.dart';
import 'package:uuid/uuid.dart';

import '../Custom/Constants.dart';
import '../Custom/Users.dart';
import '../Enums/Sign In Status.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

import 'package:the_apple_sign_in/the_apple_sign_in.dart';


User? user;

class UsersFirebase{

  Future<CreateAccountStatus>createUser(Users users, String password) async {

    try {
      //try creating user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: users.email, password: password);

      user = userCredential.user;

      users.id = user!.uid ?? '';


      //client.token = await PushNotifications().initNotifications();

      //create a reference to new client into 'clients' database. Storing with id 'user.id'
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .withConverter(
          fromFirestore: Users.fromFireStore,
          toFirestore: (Users users, options) => users.toFireStore())
          .doc(user!.uid);

      docRef.set(users);
    } on FirebaseException catch (e) {
      print(e);
      if(e.code == 'email-already-in-use'){
        return CreateAccountStatus.emailInUse;
      }else if(e.code == 'invalid-email'){
        return CreateAccountStatus.incorrectEmailFormat;
      }else if(e.code == 'operation-not-allowed'){
        return CreateAccountStatus.emailInUse;
      }else if(e.code=='weak-password'){
        return CreateAccountStatus.weakPassword;
      }else{
        return CreateAccountStatus.passwordNotLongEnough;
      }
    }


    return CreateAccountStatus.success;
  }

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
      notificationsOn: true,
      version: 1.1);

  ///Sign in with Google. If email exists in database, it will use email to obtain client object from firestore. If it does not exist, client object will be created and stored in firestore
  Future<Users> signInWithGoogle() async {

    ConstantDatabase constantDatabase = ConstantDatabase();

    //begin interactive process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();


    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);


    //search through database to see if client exists
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: gUser.email)
        .withConverter(
        fromFirestore: Users.fromFireStore,
        toFirestore: (Users users, options) => users.toFireStore());

    //reference document if we need to create a new client in database

    var docSnap = await docRef.get().then((value) async => {
      for (var docSnapshot in value.docs)
        {
          //if email already exists, assign client variable. If item does not exist, no client variable will be return and method continues on

          users = await getUserViaEmail(docSnapshot.data().email),
          //method created above
          print("User gotten: ${users.email}")
        }
    });

    print("Google User: ${gUser.email}, ${gUser.displayName}");
    print("Google User: ${users.email}, ${users.firstName}");

    await FirebaseAuth.instance
        .signInWithCredential(credential); //sign in user with google

    var uuid = Uuid();
    var uniqueID = uuid.v4();

    final createRef = FirebaseFirestore.instance
        .collection('users')
        .withConverter(
        fromFirestore: Users.fromFireStore,
        toFirestore: (Users users, options) => users.toFireStore())
        .doc(FirebaseAuth.instance.currentUser!.uid);

    if (users.email == '') {
      //if client is still empty, create client in database
      users.email = gUser.email;
      users.token = '';
      users.birthday = DateTime.now();
      users.activeAccount = true;
      users.admin = false;
      users.phoneNumber = '';
      users.notificationsOn = true;
      users.id = FirebaseAuth.instance.currentUser!.uid;
      users.version =  constantDatabase.version;

      //split display name into first and last name client variables (google has it as a whole name)

      var name =
      gUser.displayName!.split(' '); //get first occurrence of a space
      String firstName = name[0].trim();

      String lastName = '';
      if (name.length > 1) {
        //to make sure we don't go beyond scope and cause app to crash
        lastName = name[1].trim();
      }

      //store names in client variable
      users.firstName = firstName;
      users.lastName = lastName;

      await createRef.set(users);
    }

    return users;
  }

  Future<Users> getUserViaEmail(String email) async {
    //if user is logged in

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .withConverter(
        fromFirestore: Users.fromFireStore,
        toFirestore: (Users users, options) => users.toFireStore())
        .get()
        .then((value) => {
      for (var snap in value.docs) {users = snap.data()}
    });

    return users; //return data
  }


  Future<Users> getUserViaId(String id) async {
    //if user is logged in


    print("User ID ${id}");


    final docRef = FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .withConverter(
        fromFirestore: Users.fromFireStore,
        toFirestore: (Users users, options) => users.toFireStore())
        .get()
        .then((value) async => {
      for (var snap in value.docs) {users = await snap.data(),
        print('In for loop ${users.firstName}')
     }
    });

    return users; //return data
  }

  Future<Users> getUser() async {
    //if user is logged in
    if (FirebaseAuth.instance.currentUser != null) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .withConverter(
          fromFirestore: Users.fromFireStore,
          toFirestore: (Users users, options) => users.toFireStore());

      final docSnap = await docRef.get(); // get data

      return docSnap.data()!; //return data
    } else {
      //return empty client variable
      return Users(
          firstName: 'Not Signed In',
          lastName: "",
          email: '',
          birthday: DateTime.now(),
          id: '',
          token: '',
          activeAccount: false,
          admin: false,
          phoneNumber: '',
          notificationsOn: true,
          cartTotal: 0.00,
          version: 1.1);
    }
  }

  Future<SignInStatus> signIn(String email, String password) async {
    print('email: $email');
    print("pass: $password");
    try {
      print('here');

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print('here');
      user = userCredential.user;
    } on FirebaseException catch (e) {
      print("Error: ${e}");
      if (e.code == 'invalid-email') {
        return SignInStatus.invalidEmail;
      } else if (e.code == 'user-disabled') {
        return SignInStatus.disabled;
      } else if (e.code == 'user-not-found') {
        return SignInStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        return SignInStatus.wrongPassword;
      } else {
        return SignInStatus.invalidCred;
      }
    }

    return SignInStatus.success;
  }

  signOutUser(){
    FirebaseAuth.instance.signOut();

  }


  void createUserWithLinkToEmail(Users users) {
    print("Client email : ${users.email}");

    var acs = ActionCodeSettings(
      url: 'https://localhost',
      handleCodeInApp: true,
      iOSBundleId: "com.example.projectBlueBird ",
      androidPackageName: "com.Citex.project_blue_bird",
    );

    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: users.email, actionCodeSettings: acs)
        .catchError(
            (onError) => print("Error sending email verification: $onError "))
        .then((value) => print("Successfully sent email verification"));
  }


  Future editUser(Users users, String firstName,
      String lastName,
      String phoneNumber,
      String addressLine1,
      String addressLine2,
      String city,
      String state,
      String zipCode) async{

    final createRef =
    FirebaseFirestore.instance.collection('users').doc(users.id);

    if (addressLine1 != '') {
      createRef.update({'addressLine1': addressLine1});
    }
    if (addressLine2 != '') {
      createRef.update({'addressLine2': addressLine2});
    }
    if (city != '') {
      createRef.update({'city': city});
    }
    if (state != '') {
      createRef.update({'state': state});
    }
    if (zipCode != '') {
      createRef.update({'zipCode':zipCode});
    }

    if(phoneNumber != ""){
      createRef.update({'phoneNumber': phoneNumber});
    }
    if(firstName != ""){
      createRef.update({'firstName': firstName});
    }
    if(lastName != ""){
      createRef.update({'lastName': lastName});
    }
  }

  toggleUserAdmin(Users users){
    final createRef =
    FirebaseFirestore.instance.collection('users').doc(users.id);

      createRef.update({'admin': !users.admin});


  }

  Future realignTotalBalance(num balance)async{

    final newBalance = <String, num>{
      'totalBalance':balance
    };

    final createRef =
    FirebaseFirestore.instance.collection('totalBalance').doc("123456");

    createRef.set(newBalance);

  }


  Future signInWithApple()async{
    final appleProvider = AppleAuthProvider();

    UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);

    String? authCode = userCredential.additionalUserInfo?.authorizationCode;

    await FirebaseAuth.instance.revokeTokenWithAuthorizationCode(authCode!);


  }


//   Future signInWithApple(BuildContext context)async{
//
//
//     ConstantDatabase constantDatabase = ConstantDatabase();
//
//
//     Users users = Users(
//         firstName: '',
//         lastName: '',
//         email: '',
//         birthday: DateTime.now(),
//         id: '',
//         token: '',
//         activeAccount: true,
//         admin: false,
//         phoneNumber: '',
//         notificationsOn: true,
//         version: constantDatabase.version);
//
//     final AuthorizationResult result = await TheAppleSignIn.performRequests([
//       AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
//     ]);
//
//
//     switch(result.status){
//       case AuthorizationStatus.authorized:
//
//         //await const FlutterSecureStorage().write(key: 'userId', value: result.credential!.user);
//
//         final appleIDCredential = result.credential!;
//         final oAuthProvider = OAuthProvider('apple.com');
//         final credential = oAuthProvider.credential(
//           idToken: String.fromCharCodes(appleIDCredential.identityToken!),
//           accessToken: String.fromCharCodes(appleIDCredential.authorizationCode!)
//         );
//
//
//
//         final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//
//         print('apple email ${userCredential.user!.email}');
//
//         //search through database to see if client exists
//         final docRef = FirebaseFirestore.instance
//             .collection('users')
//             .where('email', isEqualTo: userCredential.user!.email)
//             .withConverter(
//             fromFirestore: Users.fromFireStore,
//             toFirestore: (Users users, options) => users.toFireStore());
//
//         //reference document if we need to create a new client in database
//
//         var docSnap = await docRef.get().then((value) async => {
//           for (var docSnapshot in value.docs)
//             {
//               //if email already exists, assign client variable. If item does not exist, no client variable will be return and method continues on
//
//               users = await getUserViaEmail(docSnapshot.data().email),
//               //method created above
//
//             }
//         });
//
//
//
//
//         if (users.email == '') {
//
//
//
// print("${userCredential.user!.displayName}");
// print("${result.credential!.fullName!.familyName!}");
//
//
//           //split display name
//           if (result.credential!.fullName!.familyName != null) {
//             // var name =
//             // userCredential.user!.displayName!.split(' '); //get first occurrence of a space
//             // String firstName = name[0].trim();
//             //
//             // String lastName = '';
//             // if (name.length > 1) {
//             //   //to make sure we don't go beyond scope and cause app to crash
//             //   lastName = name[1].trim();
//             // }
//
//             //store names in client variable
//             users.firstName = result.credential!.fullName!.givenName!;
//             users.lastName = result.credential!.fullName!.familyName!;
//           }
//
//           var uuid = Uuid();
//
//
//           final createRef = FirebaseFirestore.instance
//               .collection('users')
//               .withConverter(
//               fromFirestore: Users.fromFireStore,
//               toFirestore: (Users users, options) => users.toFireStore())
//               .doc(FirebaseAuth.instance.currentUser!.uid);
//
//
//           //if client is still empty, create client in database
//           users.token = '';
//           users.birthday = DateTime.now();
//           users.activeAccount = true;
//           users.admin = false;
//           users.phoneNumber = '';
//           users.notificationsOn = true;
//           users.id = FirebaseAuth.instance.currentUser!.uid;
//           users.version = constantDatabase.version;
//           users.email = userCredential.user!.email!;
//
//           await createRef.set(users);
//
//         }
//
//       //  final userId = await FlutterSecureStorage().read(key: 'userId');
//
//       //  TheAppleSignIn.getCredentialState(userId!);
//         return users;
//
//         break;
//
//       case AuthorizationStatus.error:
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
//
//         break;
//
//       case AuthorizationStatus.cancelled:
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Cancelled")));
//         break;
//     }
//
//
//
//   }

  // Future signInWithApple()async{
  //
  //   ConstantDatabase constantDatabase = ConstantDatabase();
  //
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     webAuthenticationOptions: WebAuthenticationOptions(
  //       // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
  //       clientId:
  //       'de.lunaone.flutter.signinwithappleexample.service',
  //
  //       redirectUri:
  //       // For web your redirect URI needs to be the host of the "current page",
  //       // while for Android you will be using the API server that redirects back into your app via a deep link
  //       kIsWeb
  //           ? Uri.parse('https://')
  //           : Uri.parse(
  //         'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
  //       ),
  //     ),
  //     // TODO: Remove these if you have no need for them
  //     nonce: 'example-nonce',
  //     state: 'example-state',
  //   );
  //
  //   // ignore: avoid_print
  //   print(credential);
  //
  //   // This is the endpoint that will convert an authorization code obtained
  //   // via Sign in with Apple into a session in your system
  //   final signInWithAppleEndpoint = Uri(
  //     scheme: 'https',
  //     host: 'flutter-sign-in-with-apple-example.glitch.me',
  //     path: '/sign_in_with_apple',
  //     queryParameters: <String, String>{
  //       'code': credential.authorizationCode,
  //       if (credential.givenName != null)
  //         'firstName': credential.givenName!,
  //       if (credential.familyName != null)
  //         'lastName': credential.familyName!,
  //       'useBundleId':
  //       !kIsWeb && (Platform.isIOS || Platform.isMacOS)
  //           ? 'true'
  //           : 'false',
  //       if (credential.state != null) 'state': credential.state!,
  //     },
  //   );
  //
  //   final session = await http.Client().post(
  //     signInWithAppleEndpoint,
  //   );
  //
  //
  //   final appleProvider = AppleAuthProvider();
  //
  //   await FirebaseAuth.instance
  //       .signInWithProvider(appleProvider); //sign in user with apple
  //
  //
  //
  //   var uuid = Uuid();
  //
  //   final createRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .withConverter(
  //       fromFirestore: Users.fromFireStore,
  //       toFirestore: (Users users, options) => users.toFireStore())
  //       .doc(FirebaseAuth.instance.currentUser!.uid);
  //
  //   if (users.email == '') {
  //     //if client is still empty, create client in database
  //     if(credential.email != null) {
  //       users.email = credential.email!;
  //     }else{
  //       users.email = 'noEmailProvided';
  //     }
  //     users.token = '';
  //     users.birthday = DateTime.now();
  //     users.activeAccount = true;
  //     users.admin = false;
  //     users.phoneNumber = '';
  //     users.notificationsOn = true;
  //     users.id = FirebaseAuth.instance.currentUser!.uid;
  //     users.version =  constantDatabase.version;
  //
  //
  //
  //     //store names in client variable
  //     if(credential.givenName!= null) {
  //       users.firstName = credential.givenName!;
  //     }else{
  //       users.firstName = '';
  //     }
  //     if(credential.familyName != null){
  //       users.lastName = credential.familyName!;
  //     }else{
  //       users.lastName = '';
  //     }
  //
  //     await createRef.set(users);
  //   }
  //
  //   return users;
  //
  // }


}