import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:danggnn/repository/local_storage_repository.dart';

class ContentsRepository extends LocalStorageRepository {
  // 실제로 데이터를 받아올수도 있는 곳
  final String MY_FAVORITE_STORE_KEY = "MY_FAVORITE_STORE_KEY";


  Future<List?> loadFavoriteContents() async {
    String? jsonString = await this.getStoredValue(MY_FAVORITE_STORE_KEY);
    if (jsonString != null) {
      List<dynamic> json = jsonDecode(jsonString);
      return json;
    } else {
      return null;
    }
  }

  addMyFavoriteContent(Map<String, String> content) async {
    List? favoriteContentList = await loadFavoriteContents();
    if (favoriteContentList == null || !(favoriteContentList is List)) {
      favoriteContentList = [content];
    } else {
      favoriteContentList.add(content);
    }
    updateFavoriteContent(favoriteContentList);
  }

  void updateFavoriteContent(List favoriteContentList) async {
    await this
        .storeValue(MY_FAVORITE_STORE_KEY, jsonEncode(favoriteContentList));
  }

  deleteFavoriteContent(String cid) async {
    List? favoriteContentList = await loadFavoriteContents();
    if (favoriteContentList != null && favoriteContentList is List) {
      favoriteContentList.removeWhere((data) => data["cid"] == cid);
    }
    updateFavoriteContent(favoriteContentList!);
  }

  isMyFavoritecontents(String cid) async {
    bool isMyFavoriteContent = false;
    List? json = await loadFavoriteContents();
    if (json == null || !(json is List)) {
      return false;
    } else {
      for (dynamic data in json) {
        if (data["cid"] == cid) {
          isMyFavoriteContent = true;
          break;
        }
      }
    }
    return isMyFavoriteContent;
  }
}
