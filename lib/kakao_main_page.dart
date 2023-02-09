import 'package:flutter/material.dart';
import 'package:flutter_api_projext/data/kakao_main.dart';

import 'package:flutter_api_projext/data/kakao_view.dart';

class KakaoMainPage extends StatefulWidget {
  const KakaoMainPage({super.key});

  @override
  State<KakaoMainPage> createState() => _KakaoMainPageState();
}

class _KakaoMainPageState extends State<KakaoMainPage> {
  final viewModel = KakaoView(KakaoMain());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? '',
              ),
              Text(
                '${viewModel.isLogined}',
              ),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.login();
                  setState(() {});
                },
                child: const Text('로그인'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.logout();
                  setState(() {});
                },
                child: const Text('로그아웃'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
