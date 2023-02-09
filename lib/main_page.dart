import 'package:flutter/material.dart';
import 'package:flutter_api_projext/main/favorite_page.dart';
import 'package:flutter_api_projext/main/map_page.dart';
import 'package:flutter_api_projext/main/setting_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
        children: const [
          MapPage(),
          FavoritePage(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: TabBar(
        tabs: const [
          Tab(
            icon: Icon(
              Icons.map,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.star,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.settings,
            ),
          ),
        ],
        labelColor: Colors.amber,
        indicatorColor: Colors.deepOrangeAccent,
        controller: controller,
      ),
    );
  }
}
