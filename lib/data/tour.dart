class TourData {
  String? title;
  String? tel;
  String? zipcode;
  String? address;
  String? address2;
  var id;
  var mapx;
  var mapy;
  String? imagePath;
  String? imagePath2;

  TourData({
    required this.title,
    required this.tel,
    required this.zipcode,
    required this.address,
    required this.address2,
    required this.id,
    required this.mapx,
    required this.mapy,
    required this.imagePath,
    required this.imagePath2,
  });

  TourData.fromJson(Map data)
      : id = data['contentid'],
        title = data['title'],
        tel = data['tel'],
        address = data['addr1'],
        address2 = data['addr2'],
        mapx = data['mapx'],
        mapy = data['mapy'],
        imagePath = data['firstimage'],
        imagePath2 = data['firstimage2'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'tel': tel,
      'address': address,
      'address2': address2,
      'mapx': mapx,
      'mapy': mapy,
      'imagePath': imagePath,
      'imagePath2': imagePath2,
    };
  }
}
