// ignore_for_file: avoid_print

/*import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/Login/login_screen.dart';

String TAG = "HomePage";



class FireAuth {
  // For registering a new user
  static Future<User?> registerUsingEmailPassword(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
      user = userCredential.user;
      try {
        final prefs = await SharedPreferences.getInstance();
        userID = user!.uid;
        prefs.setString('uid', user.uid);
      } catch (e) {}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        snackBarMassage(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        snackBarMassage(context, 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      try {
        final prefs = await SharedPreferences.getInstance();
        userID = user!.uid;
        prefs.setString('uid', user.uid);

        var testName = user.displayName;
        if (testName != null) {
          prefs.setString('name', testName);
        }
        var testEmail = user.email;
        if (testEmail != null) {
          prefs.setString('email', testEmail);
        }
        prefs.setString('password', password);
      } catch (e) {}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBarMassage(context, 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        snackBarMassage(context, 'Wrong password provided.');
        print('Wrong password provided.');
      }
    }

    return user;
  }

  static Future<User?> refreshUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future<int> testLogin() async {
    int state = 0;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');

        state = 1;
      }
    });

    return state;
  }

  /*static void showOWnLocation(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ShowLocation()),
      (Route<dynamic> route) => false,
    );
  }*/

 static void snackBarMassage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }

  static Future<void> logOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreenApp()),
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future<void> signInAnonymously() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
  }
}

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (message) async {
        if (message.data.containsKey('data')) {
          // Handle data message
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
          streamCtlr.sink.add(message.data['notification']);
        }
        // Or do other work.
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );
    // With this token you can test it easily on your phone
    final token = _firebaseMessaging.getToken().then((value) async {
      print('Token: $value');
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      //set app token in the firebase firestore
      await FirebaseMessaging.instance.getToken().then((value) async {
        // get app token
        String token = value as String;
        // set token in firestore
        await FirebaseFirestore.instance
            .collection('GpsTracking')
            .doc(uid)
            .collection("Token")
            .doc("Token")
            .set({"Token": token})
            .then((value) => print("Tokken Added"))
            .catchError((error) => print("Failed to add Token: $error"));
      });
    });
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}
*/

