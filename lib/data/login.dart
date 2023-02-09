import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_projext/data/kakao_main.dart';
import 'package:flutter_api_projext/data/kakao_view.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  double opacity = 0;
  AnimationController? _animationController;
  Animation? _animation;
  kakao.User? user;
  final viewModel = KakaoView(KakaoMain());

  bool visible = false;

  Future<dynamic> loginkakao() async {
    await viewModel.login();

    try {
      if (viewModel.isLogined) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/main');
      } else {}
    } catch (e) {
      debugPrint('에러입니다:$e');
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0, end: pi * 2).animate(_animationController!);
    _animationController!.repeat();
    Timer(
      const Duration(seconds: 2),
      () {
        setState(() {
          opacity = 1;
        });
      },
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SizedBox(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation!.value,
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.airplanemode_active,
                      color: Colors.deepOrangeAccent,
                      size: 80,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opacity,
                    duration: const Duration(seconds: 1),
                    child: const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          '모두의 여행',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opacity,
                    duration: const Duration(seconds: 1),
                    child: StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  loginkakao();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('images/kakaologin.png'),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: visible,
                                child: const CircularProgressIndicator(),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
