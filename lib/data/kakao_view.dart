import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_api_projext/data/kakao_login.dart';
import 'package:flutter_api_projext/main/firebase_auth_remote.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class KakaoView {
  final _firevaseAuthData = FirebaseAuthRemote();
  final KakaoLogin _kakaoLogin;
  bool isLogined = false;
  bool visible = false;
  kakao.User? user;

  KakaoView(this._kakaoLogin);

  Future login() async {
    isLogined = await _kakaoLogin.login();

    if (isLogined) {
      user = await kakao.UserApi.instance.me();
      print('로그인 된거');
      print(user?.properties?.values);
      final token = await _firevaseAuthData.createCustomToken({
        'uid': user!.id.toString(),
        'displayName': user!.kakaoAccount!.profile!.nickname,
        'email': user!.kakaoAccount!.email!,
      });

      await FirebaseAuth.instance.signInWithCustomToken(token);
    }
  }

  Future logout() async {
    await _kakaoLogin.logout();
    await FirebaseAuth.instance.signOut();
    isLogined = false;
    user = null;
    print('로그아웃 된거');
  }
}
