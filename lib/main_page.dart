import 'package:flutter/material.dart';
import 'package:flutter_api_projext/main/favorite_page.dart';
import 'package:flutter_api_projext/main/map_page.dart';
import 'package:flutter_api_projext/main/setting_page.dart';
import 'package:sqflite/sqflite.dart';

class MainPage extends StatefulWidget {
  final Future<Database> database;
  const MainPage({super.key, required this.database});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: [
          MapPage(
            db: widget.database,
          ),
          FavoritePage(
            db: widget.database,
          ),
          const SettingPage(),
        ],
      ),
      bottomNavigationBar: TabBar(
        tabs: const [
          Tab(
            icon: Icon(
              Icons.map,
            ),
            text: '검색하기',
          ),
          Tab(
            icon: Icon(
              Icons.star,
            ),
            text: '즐겨찾기',
          ),
          Tab(
            icon: Icon(
              Icons.settings,
            ),
            text: '환경설정',
          ),
        ],
        labelColor: Colors.blueAccent,
        indicatorColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: const EdgeInsets.all(5),
        controller: controller,
      ),
    );
  }
}
