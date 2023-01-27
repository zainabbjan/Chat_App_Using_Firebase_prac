import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_firebase/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: ((context, fsnapshot) {
          if (fsnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final chatDocs = snapshot.data!.docs;
                return ListView.builder(
                    reverse: true,
                    itemCount: chatDocs.length,
                    itemBuilder: ((context, index) {
                      return MessageBubble(
                        message: chatDocs[index]['text'],
                        isMe: chatDocs[index]['userId'] == fsnapshot.data!.uid,
                        kkey: ValueKey(chatDocs[index].id),
                        userId: chatDocs[index]['username'],
                        userImage: chatDocs[index]['userImage'],
                      );
                    }));
              }));
        }));
  }
}
