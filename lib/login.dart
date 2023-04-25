import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myteam/data/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin{
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://myteam-b79d1-default-rtdb.firebaseio.com/';
  double opacity = 0;
  AnimationController? _animationController;
  Animation? _animation;
  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;

  @override
  void initState() {
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();

    _animationController = AnimationController(duration: Duration(seconds: 30), vsync: this);
    _animation = Tween<double>(begin: 0, end: pi * 2).animate(_animationController!);
    _animationController!.repeat();

    Timer(Duration(seconds: 2), () {
      setState(() {
        opacity = 1;
      });
    });

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference().child('user');
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Widget mainTitle() {
    return const SizedBox(
      height: 100,
      child: Center(
        child: Text(
          'My FootBall Team',
          style: TextStyle(fontSize: 30),),),);
  }

  Widget editTextID() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: _idTextController,
        maxLines: 1,
        decoration: const InputDecoration(labelText: '아이디',
          border: OutlineInputBorder()),),
    );
  }

  Widget editTextPW() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: _pwTextController,
        maxLines: 1,
        decoration: const InputDecoration(labelText: '비밀번호',
            border: OutlineInputBorder()),),
    );
  }

  Widget buttonSign() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/sign');
        },
        child: Text('회원가입'));
  }
  Widget buttonLogin() {
    return TextButton(
        onPressed: () {
          if (_idTextController!.value.text.length == 0 ||
              _pwTextController!.value.text.length == 0) {
            makeDialog('빈칸이 있습니다');
          } else {
            reference!
                .child(_idTextController!.value.text)
                .onValue
                .listen((event) {
                  if (event.snapshot.value == null) {
                    makeDialog('아이디가 없습니다');
                  } else {
                    reference!
                        .child(_idTextController!.value.text)
                        .onChildAdded
                        .listen((event) {
                          User user = User.fromSnapshot(event.snapshot);
                          var bytes = utf8.encode(_pwTextController!.value.text);
                          var digest = sha1.convert(bytes);
                          if (user.pw == digest.toString()) {
                            // makeDialog('아이디가 확인되었습니다. 로그인 준비중입니다.');
                            Navigator.of(context).pushReplacementNamed('/main', arguments: _idTextController!.value.text);
                          } else {
                            makeDialog('비밀번호가 틀립니다');
                          }
                    });
                  }
            });
          }
        },
        child: Text('로그인'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedPlane(),
              mainTitle(),
              AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(seconds: 1),
                  child: Column(
                    children: <Widget>[
                      editTextID(),
                      const SizedBox(
                        height: 20,),
                      editTextPW(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buttonSign(),
                          buttonLogin(),
                        ],
                      )
                    ],),)],
          ),),),
    );
  }

  Widget AnimatedPlane() {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, widget) {
        return Transform.rotate(
          angle: _animation!.value,
          child: widget,);
      },
      child: const Icon(
        Icons.sports_soccer,
        color: Colors.blueAccent,
        // Icons.airplanemode_active,
        // color: Colors.deepOrangeAccent,
        size: 100,),);
  }
}
