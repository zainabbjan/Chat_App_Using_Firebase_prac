import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udemy_firebase/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  // Auth _submit(context, Auth auth) {
  //   return auth;
  // }

  _submitAuthForm(String email, String password, String username, bool isLogin,
      File image) async {
    UserCredential userCredential;
    print("_submitAuthForm");
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        ///
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print("createCreadentials=======> ${userCredential.user!.email}");

        ///image
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCredential.user!.uid}.jpg');

        print("image =====> $ref");

        await ref.putFile(image);
        final url =await ref.getDownloadURL();

        print("url $url");

        ///create user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url
        }).then((value) => print("user created"));
      }
    } on PlatformException catch (e) {
      var message = 'An error occured ,please check your credentials';
      if (e.message != null) {
        message = e.message.toString();
      }
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
