import 'package:flutter/material.dart';
import 'package:flutter_api_projext/data/tour.dart';
import 'package:flutter_api_projext/main/tour_detail_page.dart';
import 'package:sqflite/sqflite.dart';

class FavoritePage extends StatefulWidget {
  final Future<Database>? db;
  const FavoritePage({super.key, this.db});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Future<List<TourData>>? _tourList;

  @override
  void initState() {
    super.initState();
    _tourList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const CircularProgressIndicator();
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        List<TourData> tourList =
                            snapshot.data as List<TourData>;
                        TourData info = tourList[index];
                        return Card(
                          child: InkWell(
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'tourinfo$index',
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 0,
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: getImage(
                                          info.imagePath!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        info.title!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          '주소 : ${info.address}${info.address2}'),
                                      info.tel != 'null'
                                          ? Text('전화번호 : ${info.tel}')
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TourDetailPage(
                                    index: index,
                                    tourData: info,
                                  ),
                                ),
                              );
                            },
                            onDoubleTap: () {
                              deleteTour(widget.db!, info);
                            },
                          ),
                        );
                      },
                      itemCount: (snapshot.data!).length,
                    );
                  } else {
                    return const Text('No data');
                  }
              }
              // return const CircularProgressIndicator();
            },
            future: _tourList,
          ),
        ),
      ),
    );
  }

  ImageProvider getImage(String imagePath) {
    if (imagePath != '') {
      return NetworkImage(imagePath);
    } else {
      return const AssetImage('images/noimage.png');
    }
  }

  void deleteTour(Future<Database> db, TourData info) async {
    final Database database = await db;
    await database.delete('place2',
        where: 'title=?', whereArgs: [info.title]).then((value) {
      setState(() {
        _tourList = getTodos();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('즐겨찾기를 해제합니다')));
    });
  }

  Future<List<TourData>> getTodos() async {
    final Database database = await widget.db!;
    final List<Map<String, dynamic>> map = await database.query('place2');

    return List.generate(map.length, (index) {
      return TourData(
        title: map[index]['title'].toString(),
        tel: map[index]['tel'].toString(),
        zipcode: map[index]['zipcode'].toString(),
        address: map[index]['address'].toString(),
        address2: map[index]['address2'].toString(),
        mapx: map[index]['mapx'].toString(),
        mapy: map[index]['mapy'].toString(),
        imagePath: map[index]['imagePath'].toString(),
      );
    });
  }
}
