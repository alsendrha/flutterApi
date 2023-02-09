import 'package:flutter/material.dart';
import 'package:flutter_api_projext/data/kakao_main.dart';
import 'package:flutter_api_projext/data/kakao_view.dart';
import 'package:flutter_api_projext/data/list_data.dart';
import 'package:flutter_api_projext/data/tour.dart';
import 'package:flutter_api_projext/main/tour_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class MapPage extends StatefulWidget {
  // final DatabaseReference? databaseReference;
  final Future<Database>? db;
  // final String? id;
  const MapPage({super.key, this.db});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final viewModel = KakaoView(KakaoMain());
  List<DropdownMenuItem<Item>> list = List.empty(growable: true);
  List<DropdownMenuItem<Item>> sublist = List.empty(growable: true);
  List<TourData> tourData = List.empty(growable: true);
  ScrollController? _scrollController;

  String authKey =
      'D6HvbqfFj6otDTGY3883h0C51xIplWlMUXEF%2Bl5ZX9DTpTTNODdcI%2F6StO1BbYtjTAtOOKyj25hhnMVj4ASszw%3D%3D';
  Item? area;
  Item? kind;
  int page = 1;

  @override
  void initState() {
    super.initState();
    list = Area().seoulArea;
    sublist = Kind().kinds;

    area = list[0].value;
    kind = sublist[0].value;

    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        page++;
        getAreaList(area: area!.value, contentTypeId: kind!.value, page: page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('검색하기'),
          actions: [
            IconButton(
              onPressed: () async {
                await viewModel.logout();
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton<Item>(
                      items: list,
                      onChanged: (value) {
                        Item selectedItem = value!;
                        setState(() {
                          area = selectedItem;
                        });
                      },
                      value: area,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton<Item>(
                      items: sublist,
                      onChanged: (value) {
                        Item selectedItem = value!;
                        setState(() {
                          kind = selectedItem;
                        });
                      },
                      value: kind,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        page = 1;
                        tourData.clear();
                        getAreaList(
                          area: area!.value,
                          contentTypeId: kind!.value,
                          page: page,
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blueAccent,
                        ),
                      ),
                      child: const Text(
                        '검색하기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
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
                                        tourData[index].imagePath,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tourData[index].title!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '주소 : ${tourData[index].address}${tourData[index].address2}',
                                    ),
                                    tourData[index].tel != null
                                        ? Text('전화번호 : ${tourData[index].tel}')
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
                                  tourData: tourData[index],
                                  index: index,
                                  // databaseReference: widget.databaseReference,
                                ),
                              ),
                            );
                            print('타이틀 : ${tourData[index].title} 노데이터 클릭중이야');
                          },
                        ),
                      );
                    },
                    itemCount: tourData.length,
                    controller: _scrollController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider getImage(String? imagePath) {
    if (imagePath != null && imagePath != '') {
      return NetworkImage(imagePath);
    } else {
      return const AssetImage('images/noimage.png');
    }
  }

  void getAreaList(
      {required int area,
      required int contentTypeId,
      required int page}) async {
    var url =
        'http://apis.data.go.kr/B551011/KorService/areaBasedList?serviceKey=$authKey&numOfRows=1000&pageNo=$page&MobileOS=ETC&MobileApp=AppTest&_type=json&listYN=Y&arrange=C&areaCode=1&sigunguCode=$area';
    if (contentTypeId != 0) {
      url = '$url&contentTypeId=$contentTypeId';
    }
    var response = await http.get(Uri.parse(url));
    String body = utf8.decode(response.bodyBytes);
    var json = jsonDecode(body);
    if (json['response']['header']['resultCode'] == '0000') {
      if (json['response']['body']['items'] == '') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('마지막 데이터 입니다'),
            );
          },
        );
      } else {
        List jsonArray = json['response']['body']['items']['item'];
        for (var s in jsonArray) {
          setState(() {
            tourData.add(TourData.fromJson(s));
          });
        }
      }
    } else {
      print('error');
    }
  }
}
