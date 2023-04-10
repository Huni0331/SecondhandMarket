import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final _controller = TextEditingController();
  var _userEnterMessage = '';
  var myName = Get.arguments[1].toString();
  var yourName = Get.arguments[0].toString();
  void _sendMessage(){
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('messages')
        .doc(int.parse(myName) > int.parse(yourName) ? myName+'_'+yourName : yourName+'_'+myName)
        .collection(int.parse(myName) > int.parse(yourName) ? myName+'_'+yourName : yourName+'_'+myName)
        .add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userId': Get.arguments[1].toString(),
    });
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
                maxLines: null,
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Send a message...'
                ),
                onChanged: (value){
                  setState(() {
                    _userEnterMessage = value;
                  });
                },
              ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.blue,),
        ],
      ),
    );
  }
}
