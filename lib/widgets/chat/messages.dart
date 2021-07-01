import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Want to return FutureBuilder first so you're not recreating the future
    //for every message
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              Center(
                child: CircularProgressIndicator(),
              );
            }
            if (chatSnapshot.data == null) {
              print(chatSnapshot);
              return Text('bruh no');
            }
            final chatDocs = chatSnapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['userId'] == futureSnapshot.data.uid,
                key: ValueKey(chatDocs[index].documentID),
              ),
            );
          },
        );
      },
    );
  }
}
