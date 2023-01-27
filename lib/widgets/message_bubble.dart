import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key kkey;
  final String userId;
  final String userImage;

  const MessageBubble(
      {super.key,
      required this.message,
      required this.isMe,
      required this.kkey,
      required this.userId,
      required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12)),
            ),
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  userId,
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  message,
                  style: const TextStyle(fontSize: 12),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
      Positioned(
          top: 0,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: userImage.isEmpty
              ? Container()
              : CircleAvatar(backgroundImage: NetworkImage(userImage)))
    ]);
  }
}
