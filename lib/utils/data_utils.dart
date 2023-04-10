import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class DataUtils {
  static final oCcy = new NumberFormat("#,###", "ko_KR");

  static String calcStringToWon(String priceString) {
    if (priceString == "무료나눔") return priceString;
    return "${oCcy.format(int.parse(priceString))}원";
  }

  static String kakaoNumberHide(int kakaoNumber) {
    String number = kakaoNumber.toString();
    String newNumber = number.replaceRange(4, number.length, 'XXXX');

    return newNumber;
  }
}

class CreateNewContents {
  late String id;
  late final String title;
  late final String price;
  late final String contentsOfSell;
  late final int kakaoNumber;
  late final String? uploadImageurl;

  CreateNewContents({
    this.id = '',
    required this.title,
    required this.price,
    required this.contentsOfSell,
    required this.kakaoNumber,
    required this.uploadImageurl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'contentsOfSell': contentsOfSell,
        'kakaoNumber': kakaoNumber,
        'uploadImageurl': uploadImageurl,
        //https://stackoverflow.com/questions/60637087/how-to-add-timestamp-on-document-create-to-firestore-from-flutter
        'createTime': FieldValue.serverTimestamp()
      };

  CreateNewContents.fromSnapshot(snapshot)
      : title = snapshot.data()['title'],
        price = snapshot.data()['price'],
        contentsOfSell = snapshot.data()['contentsOfSell'],
        kakaoNumber = snapshot.data()['kakaoNumber'],
        uploadImageurl = snapshot.data()['uploadImageurl'];
}

class CreateNewChatRoom {
  late final String chatRoomId;

  CreateNewChatRoom({
    required this.chatRoomId,
  });

  Map<String, dynamic> toJson() => {
    'chatRoomId': chatRoomId,
  };
  CreateNewChatRoom.fromSnapshot(snapshot)
      : chatRoomId = snapshot.data()['chatRoomId'];

}


