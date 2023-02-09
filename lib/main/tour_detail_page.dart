import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_api_projext/data/reviews.dart';
import 'package:flutter_api_projext/data/tour.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TourDetailPage extends StatefulWidget {
  final TourData? tourData;
  final int? index;
  // final DatabaseReference? databaseReference;
  // final String id;

  const TourDetailPage({
    super.key,
    this.tourData,
    this.index,
    // this.databaseReference,
    // required this.id,
  });

  @override
  State<TourDetailPage> createState() => _TourDetailPageState();
}

class _TourDetailPageState extends State<TourDetailPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition? _googleMapCamera;
  // TextEditingController? _reviewTextController;
  Marker? marker;
  List<Review> reviews = List.empty(growable: true);
  // final bool _disableWidget = false;
  // DisableInfo? _disableInfo;
  double disableCheck1 = 0;
  double disableCheck2 = 0;

  @override
  void initState() {
    super.initState();
    // widget.databaseReference!
    //     .child('tour')
    //     .child(widget.tourData!.id.toString())
    //     .child('review')
    //     .onChildAdded
    //     .listen((event) {
    //   if (event.snapshot.value != null) {
    //     setState(() {
    //       reviews.add(Review.fromSnapshot(event.snapshot));
    //     });
    //   }
    // });

    // _reviewTextController = TextEditingController();
    _googleMapCamera = CameraPosition(
      target: LatLng(double.parse(widget.tourData!.mapy.toString()),
          double.parse(widget.tourData!.mapx.toString())),
      zoom: 17,
    );
    MarkerId markerId = MarkerId(widget.tourData.hashCode.toString());
    marker = Marker(
      position: LatLng(double.parse(widget.tourData!.mapy.toString()),
          double.parse(widget.tourData!.mapx.toString())),
      flat: true,
      markerId: markerId,
    );
    markers[markerId] = marker!;
    // getDisableInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.tourData!.title}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(top: 10, bottom: 20),
            ),
            pinned: true,
            backgroundColor: Colors.blueAccent,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Center(
                child: Column(
                  children: [
                    Hero(
                      tag: 'tourinfo${widget.index}',
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 0,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: getImage(widget.tourData!.imagePath),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        widget.tourData!.address!,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    getGoogleMap(),
                    // _disableWidget == false
                    //     ? setDisableWidget()
                    //     : showDisableWidget(),
                  ],
                ),
              ),
            ),
          ])),
          // SliverPersistentHeader(
          //   delegate: _HeaderDelegate(
          //     minHeight: 50,
          //     maxHeight: 100,
          //     child: Container(
          //       color: Colors.lightBlueAccent,
          //       child: const Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             '후기',
          //             style: TextStyle(
          //               fontSize: 30,
          //               color: Colors.white,
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          //   pinned: true,
          // ),
        ],
      ),
    );
  }

  // getDisableInfo() {
  //   widget.databaseReference!
  //       .child('tour')
  //       .child(widget.tourData!.id.toString())
  //       .onValue
  //       .listen((event) {
  //     _disableInfo = DisableInfo.fromSnapshot(event.snapshot);
  //     if (_disableInfo!.id == null) {
  //       setState(() {
  //         _disableWidget = false;
  //       });
  //     } else {
  //       setState(() {
  //         _disableWidget = true;
  //       });
  //     }
  //   });
  // }

  ImageProvider getImage(String? imagePath) {
    if (imagePath != null && imagePath != '') {
      return NetworkImage(imagePath);
    } else {
      return const AssetImage('images/noimage.png');
    }
  }

  // setDisableWidget() {
  //   return Container(
  //     child: Center(
  //       child: Column(
  //         children: [
  //           const Text('데이터가 없습니다. 추가해주세요'),
  //           Text('시각 장애인 이용 점수 : ${disableCheck1.floor()}'),
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Slider(
  //               value: disableCheck1,
  //               onChanged: (value) {
  //                 setState(() {
  //                   disableCheck1 = value;
  //                 });
  //               },
  //             ),
  //           ),
  //           Text('지체 장애인 이용 점수 : ${disableCheck2.floor()}'),
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Slider(
  //               value: disableCheck2,
  //               min: 0,
  //               max: 10,
  //               onChanged: (value) {
  //                 setState(() {
  //                   disableCheck2 = value;
  //                 });
  //               },
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               DisableInfo info = DisableInfo(
  //                 widget.id,
  //                 disableCheck1.floor(),
  //                 disableCheck2.floor(),
  //                 DateTime.now().toIso8601String(),
  //               );
  //               widget.databaseReference!
  //                   .child('tour')
  //                   .child(widget.tourData!.id.toString())
  //                   .set(info.toJson())
  //                   .then((value) {
  //                 _disableWidget = true;
  //               });
  //             },
  //             child: const Text('데이터 저장하기'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  getGoogleMap() {
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width - 50,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _googleMapCamera!,
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }

  // showDisableWidget() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             const Icon(
  //               Icons.accessible,
  //               size: 40,
  //               color: Colors.orange,
  //             ),
  //             Text(
  //               '지체 장애 이용 점수 : ${_disableInfo!.disable2}',
  //               style: const TextStyle(
  //                 fontSize: 20,
  //               ),
  //             )
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         Text('작성자 : ${_disableInfo!.id}'),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             setState(() {
  //               _disableWidget = false;
  //             });
  //           },
  //           child: const Text('새로 작성하기'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// class _HeaderDelegate extends SliverPersistentHeaderDelegate {
//   final double? minHeight;
//   final double? maxHeight;
//   final Widget? child;

//   _HeaderDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(
//       child: child,
//     );
//   }

//   @override
//   double get maxExtent => math.max(maxHeight!, minHeight!);

//   @override
//   double get minExtent => minHeight!;

//   @override
//   bool shouldRebuild(_HeaderDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }
