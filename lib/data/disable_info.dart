import 'package:firebase_database/firebase_database.dart';

class DisableInfo {
  String? key;
  int? disable1;
  int? disable2;

  String? createTime;

  DisableInfo(
    this.disable1,
    this.disable2,
    this.createTime,
  );

  DisableInfo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        disable1 = (snapshot.value as Map)['disable1'] as int,
        disable2 = (snapshot.value as Map)['disable2'] as int,
        createTime = (snapshot.value as Map)['createTime'] as String;

  toJson() {
    return {
      'disable1': disable1,
      'disable2': disable2,
      'createTime': createTime
    };
  }
}
