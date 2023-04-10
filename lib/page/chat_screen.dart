import 'package:danggnn/chat/message.dart';
import 'package:danggnn/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String myName = Get.arguments[1].toString();
  String yourName = Get.arguments[0].toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('한밭대학교 중고 거래'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(myName, yourName),
            ),
            // NewMessage(myName, yourName),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}