import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  ///send message function
  void _sendMessage() async {
    print("sending message function");

    ///
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    ///
    print(user.uid);
    print("userData=======> ");
    print(userData["username"]);

    await FirebaseFirestore.instance
        .collection('chat')
        .add({
          'text': _enteredMessage,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'username': userData['username'],
          'userImage': userData['image_url'],
        })
        .then((value) => print("chat is added"))
        .onError(
            (error, stackTrace) => print("error ====================> $error"));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
