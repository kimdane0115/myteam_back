import 'package:firebase_database/firebase_database.dart';

class User {
  String id;
  String pw;
  String teamName;
  String createTime;
  int adminFlag;

  User(this.id, this.pw, this.teamName, this.createTime, this.adminFlag);

  User.fromSnapshot(DataSnapshot snapshot)
    :
      id = (snapshot.value as Map)['id'],
      pw = (snapshot.value as Map)['pw'],
      teamName = (snapshot.value as Map)['teamName'],
      createTime = (snapshot.value as Map)['createTime'],
      adminFlag = (snapshot.value as Map)['adminFlag'];

  toJson() {
    return {
      'id': id,
      'pw': pw,
      'teamName': teamName,
      'createTime': createTime,
      'adminFlag': adminFlag,
    };
  }
}