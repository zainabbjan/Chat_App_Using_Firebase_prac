import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udemy_firebase/widgets/chats/messages.dart';
import 'package:udemy_firebase/widgets/chats/newMessages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          DropdownButton(
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Logout')
                    ],
                  ),
                ),
              ],
              icon: const Icon(Icons.more_vert),
              onChanged: ((value) {
                if (value == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              }))
        ],
      ),
      body: Column(children: const [
        Expanded(child: Messages()),
        NewMessage(),
      ]),
    );
  }
}
