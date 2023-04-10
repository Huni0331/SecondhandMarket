import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danggnn/chat/chat_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {


  const Messages(this.myName, this.yourName, {Key? key}) : super(key: key);
  final myName;
  final yourName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(int.parse(myName) > int.parse(yourName) ? myName+'_'+yourName : yourName+'_'+myName)
          .collection(int.parse(myName) > int.parse(yourName) ? myName+'_'+yourName : yourName+'_'+myName)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            return ChatBubble(
                chatDocs[index]['text'],
                chatDocs[index]['userId'].toString() == myName
            );
          },
        );
      },
    );
  }

}
