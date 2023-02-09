import 'package:flutter_api_projext/data/kakao_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoMain implements KakaoLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          print('뭔가 에러다 1번째: $e');
          return false;
        }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          print('뭔가 에러다 2번째 : $e');
          return false;
        }
      }
    } catch (e) {
      print('뭔가 에러다 3번째 : $e');
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (e) {
      print('뭔가 에러다 4번째 : $e');
      return false;
    }
  }
}
