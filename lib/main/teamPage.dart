import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myteam/data/member.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamPage extends StatefulWidget {
  // const TeamPage({Key? key}) : super(key: key);
  final String? loginId;
  final String? teamName;
  const TeamPage({super.key, this.loginId, this.teamName});

  @override
  State<TeamPage> createState() => _TeamPage();
}

class _TeamPage extends State<TeamPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  CollectionReference? _collectionRef;
  String _databaseURL = 'https://myteam-b79d1-default-rtdb.firebaseio.com/';

  List<Member> memberData = List.empty(growable: true);

  TextEditingController? _numTextController;
  TextEditingController? _nameTextController;
  TextEditingController? _positionTextController;

  @override
  void initState() {
    super.initState();

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference().child("member");
    _collectionRef = FirebaseFirestore.instance.collection('team');

    _numTextController = TextEditingController();
    _nameTextController = TextEditingController();
    _positionTextController = TextEditingController();

    // getMemberList();
    getFireStore();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.teamName} 선수 리스트'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 12,
                // child: CustomScrollView(
                //   slivers: <Widget>[
                //     SliverFixedExtentList(
                //         delegate: SliverChildBuilderDelegate(
                //             (BuildContext context, int index) {
                //               return Container(
                //                 alignment: Alignment.center,
                //                 // color: Colors.lightBlue[100 * (index % 9)],
                //                 color: Colors.lightBlue[100 * (index % 9)],
                //                 child: Text('List Item $index', style: const TextStyle(fontSize: 10),),
                //               );
                //             }
                //         ),
                //         itemExtent: 50.0
                //     )
                //   ],
                // )
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _memberList(index);
                  },
                  itemCount: memberData.length,
                )),
            Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: TextField(
                              controller: _numTextController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  hintText: '넘버',
                                  labelText: '',
                                  border: OutlineInputBorder()),
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _positionTextController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  hintText: '포지션',
                                  labelText: '',
                                  border: OutlineInputBorder()),
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _nameTextController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  hintText: '선수명',
                                  labelText: '',
                                  border: OutlineInputBorder()),
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: () {
                                addFireStore();
                              },
                              child: const Text("추가")))
                    ]))
            )],
        ),
      ),
    );
  }

  void addMember() {
    print("name : ${_nameTextController?.value} number: ${_numTextController} position : ${_positionTextController}");
    var mem = Member(_numTextController?.text, _nameTextController?.text, _positionTextController?.text, DateTime.now().toIso8601String());
    setState(() {
      memberData.add(mem);
    });
    reference!
      .child('borussia')
      .push()
      .set(mem.toJson())
      .then((value) => print("insert Success!!"));
    print("id : ${widget.loginId} member Data size : ${memberData.length}");
  }

  void getMemberList() {
    reference!
      .child('borussia')
      .onValue
      .listen((event) {
        print("value1 : ${event.snapshot.value}");
        // if (event.snapshot.value != null) {
        //   reference!
        //       .child('borussia')
        //       .onChildAdded
        //       .listen((event) {
        //         print("last event : ${event.snapshot.value}");
        //   });
        // }
    });

    reference!
        .child('borussia')
        .onChildAdded
        .listen((event) {
          print("value2 : ${event.snapshot.value}");
        Member mem = Member.fromSnapshot(event.snapshot);
        setState(() {
          memberData.add(mem);
        });
    });

    // final snapshot = await reference?.get();
    // print("snapshot : ${snapshot?.value}");
    //
    // final map = snapshot?.value as Map<dynamic, dynamic>;
    //
    // map.forEach((key, value) {
    //   print("key1 : ${key}, value : ${value}");
    //   // value.forEach((key, value){
    //   //   print("key2: ${key}, value : ${value['insertTime']}");
    //   // });
    // });

  }

  void addFireStore() async {
    var mem = Member(_numTextController?.text, _nameTextController?.text, _positionTextController?.text, DateTime.now().toIso8601String());
    await _collectionRef!
        .doc(widget.teamName)
        .collection("member")
        .doc(_nameTextController?.text)
        .set(mem.toJson());

    setState(() {
      memberData.add(mem);
    });
  }

  void getFireStore() async {
    QuerySnapshot result = await _collectionRef!.doc(widget.teamName).collection("member").get();
    final allData = result.docs.map((doc) => doc.data()).toList();

    print("allData : ${allData}");
    for( int i = 0; i < allData.length; i++){
      var mem = Member.fromMap(allData[i] as Map<String, dynamic>);
      setState(() {
        memberData.add(mem);
      });
    }
  }

  Widget _memberList(int index) {
    return Card(
        child: InkWell(
            child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                        child: Text(
                          (memberData.isEmpty ? "" : memberData[index].number!),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 1,
                        child: Text(
                          (memberData.isEmpty ? "" : memberData[index].position!),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )
                    ),
                    Expanded(
                      flex: 3,
                        child: Text(
                          (memberData.isEmpty ? "" : memberData[index].name!),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )
                    )
          ],),)
    ));
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: const <Widget>[
//           Text("명단리스트"),
//         ],
//       ),
//     ),
//   );
// }
}

class YelloBox extends StatelessWidget {
  const YelloBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration:
          BoxDecoration(color: Colors.yellowAccent, border: Border.all()),
    );
  }
}

class EditTextBox extends StatelessWidget {
  const EditTextBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      child: TextField(
        maxLines: 1,
        decoration: InputDecoration(
            hintText: '입력', labelText: '', border: OutlineInputBorder()),
      ),
    );
  }
}
