import 'dart:developer';

import 'package:danggnn/page/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
class KakaoLoginPage extends StatefulWidget {

  @override
  _KakaoLoginPageState createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {

  bool _isKakaoTalkInstalled = false;

  @override
  void initState() {
    super.initState();
    _initKakaoTalkInstalled();
  }
  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CupertinoButton(
                onPressed: () async { _isKakaoTalkInstalled ? _loginWithTalk() : _loginWithKaKaoId();},
                color: Colors.yellow,
                child: Text(
                  '카카오 로그인',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 void _loginWithTalk() async {
  try {
    OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
    print('카카오톡으로 로그인 성공 ${token.accessToken}');
    _userInformationAndGoHome();
  } catch (error) {
    print('카카오톡으로 로그인 실패 $error');
  }
}

 void _loginWithKaKaoId() async {
  try {
    OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
    print('카카오계정으로 로그인 성공 ${token.accessToken}');
    _userInformationAndGoHome();
  } catch (error) {
    print('카카오계정으로 로그인 실패 $error');
  }
}

void _userInformationAndGoHome() async {
  try {
    User user = await UserApi.instance.me();
    log('사용자 정보 요청 성공, 회원번호 ${user.id}');
    Get.off(Home(), arguments: user.id);
  } catch (error) {
    log('$error');
  }
}



