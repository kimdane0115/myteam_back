import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Member {
  String? number;
  String? name;
  String? position;
  String? insertTime;

  Member(this.number, this.name, this.position, this.insertTime);

  Member.fromSnapshot(DataSnapshot snapshot)
      :
        number = (snapshot.value as Map)['number'],
        name = (snapshot.value as Map)['name'],
        position = (snapshot.value as Map)['position'],
        insertTime = (snapshot.value as Map)['insertTime'];

  Member.fromMap(Map<String, dynamic> snapshot)
    :
        number = (snapshot)['number'],
        name = (snapshot)['name'],
        position = (snapshot)['position'],
        insertTime = (snapshot)['insertTime'];

  toJson() {
    return {
      'number': number,
      'name': name,
      'position': position,
      'insertTime': insertTime,
    };
  }
}