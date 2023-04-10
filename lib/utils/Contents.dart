import 'package:cloud_firestore/cloud_firestore.dart';

class Contents {
  String? id;
  String? title;
  String? price;
  String? contentsOfSell;
  int? kakaoNumber;
  String? uploadImageurl;
  DateTime? createTime;

  Contents();

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

  Contents.fromSnapshot(snapshot)
      : id = snapshot.data()['id'],
        title = snapshot.data()['title'],
        price = snapshot.data()['price'],
        contentsOfSell = snapshot.data()['contentsOfSell'],
        kakaoNumber = snapshot.data()['kakaoNumber'],
        uploadImageurl = snapshot.data()['uploadImageurl'];
}