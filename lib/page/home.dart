import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danggnn/page/write.dart';
import 'package:danggnn/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../chat/chat_list.dart';
import '../utils/Contents.dart';
import 'contents_card.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //for 게시글
  List<Object> _historyList = [];

  late int _currentPageIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getContentsList();
  }

  final int getKakaoNumber = Get.arguments;
  late String currnetLocation;
  final ContentsRepository contentsRepository = ContentsRepository();

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  Future getContentsList() async {
    var data = await FirebaseFirestore.instance
        .collection('createContents')
        .orderBy('createTime', descending: true)
        .get();
    setState(() {
      _historyList =
          List.from(data.docs.map((doc) => Contents.fromSnapshot(doc)));
    });
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: Text("한밭대학교 중고 거래"),
      automaticallyImplyLeading: false,

      // elevation: 1, //appbar 그림자지우기
      actions: [
        IconButton(
          visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
          onPressed: () {},
          icon: Icon(Icons.search),
          color: Colors.white,
        ),
        IconButton(
          //로그아웃 버튼 구현
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        )
      ],
    );
  }

  _makeDataList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: _historyList.length,
      itemBuilder: (BuildContext context, int index) {
        return ContentView(_historyList[index] as Contents, getKakaoNumber);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 1, color: Colors.black.withOpacity(0.4));
      },
    );
  }

  Widget _bodyWidget() {
    return _makeDataList();
  }

  Widget _floatingActionBar() {
    return FloatingActionButton(
        backgroundColor: Color(0xff3c92a6),
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(
            writePage(),
            arguments: getKakaoNumber,
          );
        });
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String iconName,
      String label) {
    return BottomNavigationBarItem(
      activeIcon: SvgPicture.asset("assets/svg/${iconName}_on.svg", width: 26,),
        icon: SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 26,),
      label: label
    );
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      type:
      BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      selectedFontSize: 14,
      onTap: (int index){
        setState(() {
          _currentPageIndex = index;
        });
        switch (index) {
          case 0:
            Get.off(Home(), arguments: getKakaoNumber,);
            break;
          case 1:
            Get.off(ChatList(), arguments: getKakaoNumber,);
            break;
        }
      },
        currentIndex: _currentPageIndex,
        items: [
          _bottomNavigationBarItem("home", "Home"),
          _bottomNavigationBarItem("chat", "Chat"),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      floatingActionButton: _floatingActionBar(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}

