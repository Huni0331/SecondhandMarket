import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../page/home.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late int _currentPageIndex;
  final int getKakaoNumber = Get.arguments;

  List<Object> _chatlist = [];


  @override
  void initState() {
    super.initState();
    _currentPageIndex = 1;
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(
          "assets/svg/${iconName}_on.svg",
          width: 26,
        ),
        icon: SvgPicture.asset(
          "assets/svg/${iconName}_off.svg",
          width: 26,
        ),
        label: label);
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        selectedFontSize: 14,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
          switch (index) {
            case 0:
              Get.off(
                Home(),
                arguments: getKakaoNumber,
              );
              break;
            case 1:
              Get.off(
                ChatList(),
                arguments: getKakaoNumber,
              );
              break;
          }
        },
        currentIndex: _currentPageIndex,
        items: [
          _bottomNavigationBarItem("home", "Home"),
          _bottomNavigationBarItem("chat", "Chat"),
        ]);
  }

  Widget _chatListView() {
    return ListView.separated(

      itemCount: _chatlist.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(child: Text("${_chatlist.length}"+" asd"),);//ContentView(_historyList[index] as Contents, getKakaoNumber);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 1, color: Colors.black.withOpacity(0.4));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("채팅"),
      ),
      body: Center(child: Text("개발 진행 중"),),//_chatListView(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );

    // children: [Container(child: Text('CHAT'),)]);
  }
}
