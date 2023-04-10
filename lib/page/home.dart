
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danggnn/page/write.dart';
import 'package:danggnn/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    currnetLocation = "ara";
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
          onPressed: () {
          },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      floatingActionButton: _floatingActionBar(),
    );
  }
}

