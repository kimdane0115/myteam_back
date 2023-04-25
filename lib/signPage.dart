import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myteam/data/user.dart';

enum Admin { TeamAdmin, TeamMember }

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => _SignPage();
}

class _SignPage extends State<SignPage> {

  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://myteam-b79d1-default-rtdb.firebaseio.com/';

  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;
  TextEditingController? _pwCheckTextController;
  TextEditingController? _teamNameTextController;

  Admin? _admin;

  @override
  void initState() {
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _pwCheckTextController = TextEditingController();
    _teamNameTextController = TextEditingController();
    _admin = Admin.TeamMember;

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database?.reference().child('user');
  }

  TextField editSignTextID() {
    return TextField(
      controller: _idTextController,
      maxLines: 1,
      decoration: const InputDecoration(
        hintText: '4자 이상 입력해주세요',
        labelText: '아이디',
        border: OutlineInputBorder()
      ),
    );
  }

  TextField editSignTextPW() {
    return TextField(
      controller: _pwTextController,
      obscureText: true,
      maxLines: 1,
      decoration: const InputDecoration(
          hintText: '6자 이상 입력해주세요',
          labelText: '비밀번호',
          border: OutlineInputBorder()
      ),
    );
  }

  TextField editSignTextPWcheck() {
    return TextField(
      controller: _pwCheckTextController,
      obscureText: true,
      maxLines: 1,
      decoration: const InputDecoration(
          labelText: '비밀번호확인',
          border: OutlineInputBorder()
      ),
    );
  }

  TextField editSignTextTeamName() {
    return TextField(
      controller: _teamNameTextController,
      maxLines: 1,
      decoration: const InputDecoration(
          labelText: '팀명',
          border: OutlineInputBorder()
      ),
    );
  }

  Row selectTeamAdmin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: RadioListTile(
                title: const Text("팀원"),
                value: Admin.TeamMember,
                groupValue: _admin,
                onChanged: (value) {
                  setState(() {
                    _admin = value;
                  });
                })),
        Expanded(
            child: RadioListTile(
                title: const Text("팀관리자"),
                value: Admin.TeamAdmin,
                groupValue: _admin,
                onChanged: (value) {
                  setState(() {
                    _admin = value;
                  });
                }))
      ],
    );
  }

  void makeDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
          );
        });
  }

  Widget buttonSign() {
    return ElevatedButton(
        onPressed: () {
          if (_idTextController!.value.text.length >= 4 && _pwTextController!.value.text.length >= 6) {
            if (_pwTextController!.value.text == _pwCheckTextController!.value.text) {
              var bytes = utf8.encode(_pwTextController!.value.text);
              var digest = sha1.convert(bytes);
              reference!
                .child(_idTextController!.value.text)
                .push()
                .set(User(_idTextController!.value.text,
                    digest.toString(), _teamNameTextController!.value.text, DateTime.now().toIso8601String(), _admin!.index)
                    .toJson())
                .then((_) {
                  Navigator.of(context).pop();
              });
            } else {
              makeDialog('비밀번호가 틀립니다');
            }
          } else {
            makeDialog('길이가 짧습니다');
          }
        },
        child: Text(
          '회원가입',
          style: TextStyle(color: Colors.white),),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                child: editSignTextID(),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child: editSignTextPW(),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child: editSignTextPWcheck(),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child: editSignTextTeamName(),
              ),
              const SizedBox(height: 5,),
              SizedBox(
                width: 300,
                child: selectTeamAdmin(),
              ),
              const SizedBox(height: 10,),
              buttonSign(),
            ],),
        ),
    ),);
  }
}
