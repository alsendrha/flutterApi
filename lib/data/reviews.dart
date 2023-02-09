import 'package:firebase_database/firebase_database.dart';

class Review {
  String id;
  String review;
  String createTime;

  Review(this.id, this.review, this.createTime);

  Review.fromSnapshot(DataSnapshot snapshot)
      : id = (snapshot.value as Map)['id'] as String,
        review = (snapshot.value as Map)['review'] as String,
        createTime = (snapshot.value as Map)['createTime'] as String;

  toJson() {
    return {
      'id': id,
      'review': review,
      'createTime': createTime,
    };
  }
}
