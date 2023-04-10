import 'dart:io';

import 'package:danggnn/page/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../utils/data_utils.dart';
import '../utils/lineClass.dart';

class writePage extends StatefulWidget {
  const writePage({Key? key}) : super(key: key);

  @override
  State<writePage> createState() => _writePageState();
}

class _writePageState extends State<writePage> {

  final int getKakaoNumber = Get.arguments;

  //For ImagePicker
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  //For CreateContents
  TextEditingController _newTitleName = TextEditingController();
  TextEditingController _newPrice = TextEditingController();
  TextEditingController _newContents = TextEditingController();


  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: Text("중고거래 글쓰기"),
      actions: [
        TextButton(
          onPressed: () async {

            final title = _newTitleName.text; //강좌
            final price = _newPrice.text;
            final contentsOfSell = _newContents.text;
            final kakaoNumber = Get.arguments;
            final uploadImageurl = await uploadImage();

            createContents(
              title: title,
              price: price,
              contentsOfSell: contentsOfSell,
              kakaoNumber: kakaoNumber,
              uploadImageurl: uploadImageurl,
            );

            Get.off(Home(), arguments: getKakaoNumber);

          },
          child: Text(
            "완료",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xffd9965b)),
          ),
        ),
      ],
      iconTheme: IconThemeData(
        color: Colors.white,
      ), // elevation: 1, //appbar 그림자지우기
    );
  }

  Future createContents(
      {required String title,
      required String price,
      required String contentsOfSell,
      required int kakaoNumber, required String? uploadImageurl, }) async {
    final docContent =
        FirebaseFirestore.instance.collection('createContents').doc();
    final createNewContent = CreateNewContents(
      id: docContent.id,
      title: title,
      price: price,
      contentsOfSell: contentsOfSell,
      kakaoNumber: kakaoNumber,
      uploadImageurl: uploadImageurl,
    );
    final json = createNewContent.toJson();

    await docContent.set(json);
  }

  File? _image;
  Future pickImage() async {
    try {
      final pick_image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);
      if (pick_image == null) return;

      final imageTemporry = File(pick_image.path);

      setState(() {
        this._image = imageTemporry;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget showImage() {
    if (_image == null)
      return Container();
    else
      return Stack(children: [
        Container(
          width: 100,
          height: 100,
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Image.file(_image!,fit: BoxFit.fitHeight,),
          ),
        ),
        Positioned(
          right: 0,
            child: Container(
          child: IconButton(
              onPressed: () {
                clearimage();

              },
              icon: Icon(Icons.delete_forever, size: 25.0,)),
        ))
      ]);
  }
  clearimage() {
    setState(() {
      _image = null;
    });
  }

  //uploading the image
  String? downloadURL;
  Future<String?> uploadImage() async {
    String imageFileUrl = Get.arguments.toString();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    String strToday = formatter.format(now).toString();

    Reference ref = FirebaseStorage.instance.ref().child(imageFileUrl+"time:"+strToday);
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
    //print("다운로드 URL : ${downloadURL}");
    return downloadURL;
  }

  Widget _pictureButtonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            pickImage();
          },
          child: Image.asset(
            'assets/images/camera_image.png',
            height: 100,
            width: 100,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        showImage(),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  Widget _bodyWidget() {
    return Center(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: Column(
                  children: [
                    TextField(
                      maxLength: 30,
                      controller: _newTitleName,
                      decoration: InputDecoration(hintText: '글 제목',counterText: ''),
                    ),
                    TextFormField(
                      maxLength: 7,

                      //https://become-a-developer.tistory.com/entry/flutter-textfield-only-number
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: _newPrice,
                      decoration: InputDecoration(hintText: '가격',counterText: ''),
                    ),
                    TextField(
                      maxLength: 100,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _newContents,
                      decoration: InputDecoration(hintText: '내용을 입력해주세요.',counterText: '',border: InputBorder.none),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _pictureButtonWidget(),
            lineMake(),
            _bodyWidget(),
          ],
        ),
      ),
    );
  }
}
