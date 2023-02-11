import 'package:flutter/material.dart';
import 'package:flutter_api_projext/data/kakao_main.dart';
import 'package:flutter_api_projext/data/kakao_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final viewModel = KakaoView(KakaoMain());
  bool pushCheck = true;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> logoutWithGoogle() async {
    bool isLogined = false;
    print('로그아웃 된거야 $isLogined');
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정하기'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    '푸시 알림',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Switch(
                    value: pushCheck,
                    onChanged: (value) {
                      setState(() {
                        pushCheck = value;
                      });
                      _setData(value);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text('로그아웃 되었습니다'),
                      );
                    },
                  );
                  await viewModel.logout();
                  await logoutWithGoogle();
                  if (!mounted) return;
                  Navigator.of(context).pushReplacementNamed(
                    '/',
                  );
                },
                child: const Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setData(bool value) async {
    var key = 'push';
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  void _loadData() async {
    var key = 'push';
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var value = pref.getBool(key);
      if (value == null) {
        setState(() {
          pushCheck = true;
        });
      } else {
        setState(() {
          pushCheck = value;
        });
      }
    });
  }
}
