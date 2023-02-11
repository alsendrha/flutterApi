import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_api_projext/data/login.dart';
import 'package:flutter_api_projext/main_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kakao.KakaoSdk.init(nativeAppKey: '4e3fdbef82b354f15cbb3e70d4a4aa4a');
  print('해시값 : ${await kakao.KakaoSdk.origin}');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'tour_database2.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE place2(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, tel TEXT, zipcode TEXT, address TEXT, address2 TEXT, mapx Number, mapy Number, imagePath TEXT, imagePath2 TEXT)",
        );
      },
      version: 1,
    );
  }

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();
    return MaterialApp(
      title: '서울여행',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        // '/sign': (context) => const SignPage(),
        '/main': (context) => MainPage(database: database),
      },
      // home: const KakaoMainPage(),
    );
  }
}
