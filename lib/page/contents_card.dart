import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/Contents.dart';
import '../utils/data_utils.dart';
import 'detail.dart';

class ContentView extends StatelessWidget {
  final Contents _content;
  final int getKakaoNumber;


  const ContentView(this._content, this.getKakaoNumber);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Map<String, dynamic> descrip = {
          "id" : _content.id,
          "title" : _content.title,
          "uploadImageurl" : _content.uploadImageurl,
          "kakaoNumber" : _content.kakaoNumber,
          "createTime" : _content.createTime,
          "price" : _content.price,
          "contentsOfSell" : _content.contentsOfSell
          };
        Get.to(
          DetailContentView(data: descrip),
          arguments: getKakaoNumber,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Hero(
                    tag: _content.id!,
                    child: Image.network(
                      _content.uploadImageurl!,
                      width: 100,
                      height: 100,
                    )
                )),
            Expanded(
              child: Container(
                height: 100,
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _content.title!,
                      style: const TextStyle(fontSize: 15.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      DataUtils.calcStringToWon(_content.price!),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}